import 'dart:io';

import 'package:test/test.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:toptodo/blocs/init/bloc.dart';
import 'package:toptodo_data/toptodo_data.dart';

class MockCredentialsProvider extends Mock implements CredentialsProvider {}

class MockSettingsProvider extends Mock implements SettingsProvider {}

class MockTopdeskProvider extends Mock implements TopdeskProvider {}

void main() {
  group('init bloc', () {
    const credentials = Credentials(url: 'u', loginName: 'ln', password: 'pw');
    const settings = Settings(
      tdBranchId: 'a',
      tdCallerId: 'a',
      tdCategoryId: 'a',
      tdSubcategoryId: 'a',
      tdDurationId: 'a',
      tdOperatorId: 'a',
    );
    const currentOperator = TdOperator(
      id: 'a',
      name: 'a',
      avatar: 'a',
      firstLine: true,
      secondLine: true,
    );

    final cp = MockCredentialsProvider();
    final sp = MockSettingsProvider();
    final tdp = MockTopdeskProvider();

    when(cp.provide()).thenAnswer((_) => Future.value(credentials));
    when(sp.provide()).thenAnswer((_) => Future.value(settings));
    when(tdp.init(any)).thenAnswer((_) => Future.value());
    when(tdp.currentTdOperator())
        .thenAnswer((_) => Future.value(currentOperator));

    test('initial state', () async {
      final bloc = InitBloc(
        credentialsProvider: cp,
        settingsProvider: sp,
        topdeskProvider: tdp,
      );

      await emitsExactly(
        bloc,
        [
          InitData.empty(),
        ],
      );
    });

    test('request init data', () async {
      final bloc = InitBloc(
        credentialsProvider: cp,
        settingsProvider: sp,
        topdeskProvider: tdp,
      );

      final actual = <InitState>[];
      final subscription = bloc.listen(actual.add);

      bloc.add(const RequestInitData());

      await bloc.close();
      await subscription.cancel();

      expect(actual.length, 4);
      expect(actual.first, InitData.empty());
      expect(actual[1], InitData(credentials: credentials));
      expect(
        actual[3],
        InitData(
          credentials: credentials,
          currentOperator: currentOperator,
          settings: settings,
        ),
      );
    });

    test('incomplete credentials', () async {
      final incompleteCredentialsProvider = MockCredentialsProvider();
      final incompleteCredentials =
          Credentials(url: 'a', loginName: null, password: null);
      when(incompleteCredentialsProvider.provide())
          .thenAnswer((_) => Future.value(incompleteCredentials));

      final bloc = InitBloc(
        credentialsProvider: incompleteCredentialsProvider,
        settingsProvider: sp,
        topdeskProvider: tdp,
      );

      bloc.add(const RequestInitData());

      await emitsExactly(
        bloc,
        [
          InitData.empty(),
          IncompleteCredentials(incompleteCredentials),
        ],
      );
    });

    group('errors', () {
      test('init fails', () async {
        final initFailsProvider = MockTopdeskProvider();
        const exc = SocketException('error test');
        when(initFailsProvider.init(any)).thenAnswer(
          (_) => Future.delayed(Duration.zero, () => throw exc),
        );

        final bloc = InitBloc(
          credentialsProvider: cp,
          settingsProvider: sp,
          topdeskProvider: initFailsProvider,
        );

        final actual = <InitState>[];
        final subscription = bloc.listen(actual.add);

        bloc.add(const RequestInitData());

        await bloc.close();
        await subscription.cancel();

        expect(actual.last, LoadingDataFailed(exc));
      });

      test('timeout', () async {
        final timeOutTdProvider = MockTopdeskProvider();
        when(timeOutTdProvider.init(any)).thenAnswer((_) => Future.value());

        const exc = TdTimeOutException('error test');
        when(timeOutTdProvider.currentTdOperator()).thenAnswer(
          (_) => Future.delayed(Duration.zero, () => throw exc),
        );

        final bloc = InitBloc(
          credentialsProvider: cp,
          settingsProvider: sp,
          topdeskProvider: timeOutTdProvider,
        );

        final actual = <InitState>[];
        final subscription = bloc.listen(actual.add);

        bloc.add(const RequestInitData());

        await bloc.close();
        await subscription.cancel();

        expect(actual.last, LoadingDataFailed(exc));
      });

      test(
          'TopdeskProvider gives error. Stream is closed. '
          'Settings are not added to closed stream', () async {
        final settingsWithDelay = MockSettingsProvider();
        when(settingsWithDelay.provide()).thenAnswer(
            (_) => Future.delayed(Duration(milliseconds: 10), () => settings));

        final initFailsProvider = MockTopdeskProvider();
        const exc = SocketException('error test');
        when(initFailsProvider.init(any)).thenAnswer(
          (_) => Future.delayed(Duration.zero, () => throw exc),
        );

        final bloc = InitBloc(
          credentialsProvider: cp,
          settingsProvider: settingsWithDelay,
          topdeskProvider: initFailsProvider,
        );

        final actual = <InitState>[];
        final subscription = bloc.listen(actual.add);

        bloc.add(const RequestInitData());

        /// Waiting for settings provider
        await Future.delayed(Duration(milliseconds: 50));

        await bloc.close();
        await subscription.cancel();

        expect(actual.last, LoadingDataFailed(exc));
      });
    });
  });
}
