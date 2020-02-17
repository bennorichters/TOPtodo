import 'dart:io';

import 'package:test/test.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:toptodo/blocs/init/bloc.dart';
import 'package:toptodo_data/toptodo_data.dart';

import '../../helper.dart';

class MockCredentialsProvider extends Mock implements CredentialsProvider {}

class MockSettingsProvider extends Mock implements SettingsProvider {}

class MockTopdeskProvider extends Mock implements TopdeskProvider {}

void main() {
  group('init bloc', () {
    final cp = MockCredentialsProvider();
    final sp = MockSettingsProvider();
    final tdp = MockTopdeskProvider();

    when(cp.provide())
        .thenAnswer((_) => Future.value(TestConstants.credentials));
    when(sp.provide()).thenAnswer((_) => Future.value(TestConstants.settings));
    when(tdp.init(any)).thenAnswer((_) => Future.value());
    when(tdp.currentTdOperator())
        .thenAnswer((_) => Future.value(TestConstants.currentOperator));

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

      bloc.add(RequestInitData());

      await bloc.close();
      await subscription.cancel();

      expect(actual.length, 4);
      expect(actual.first, InitData.empty());
      expect(actual[1], InitData(credentials: TestConstants.credentials));
      expect(
        actual[3],
        InitData(
          credentials: TestConstants.credentials,
          currentOperator: TestConstants.currentOperator,
          settings: TestConstants.settings,
        ),
      );
    });

    test('incomplete credentials', () async {
      final incompleteCredentialsProvider = MockCredentialsProvider();
      final incompleteCredentials = Credentials(
        url: 'a',
        loginName: null,
        password: null,
      );
      when(incompleteCredentialsProvider.provide())
          .thenAnswer((_) => Future.value(incompleteCredentials));

      final bloc = InitBloc(
        credentialsProvider: incompleteCredentialsProvider,
        settingsProvider: sp,
        topdeskProvider: tdp,
      );

      bloc.add(RequestInitData());

      await emitsExactly(
        bloc,
        [
          InitData.empty(),
          InitData(credentials: incompleteCredentials),
        ],
      );
    });

    test('SettingsProvider comes last', () async {
      final settingsWithDelay = MockSettingsProvider();
      when(settingsWithDelay.provide()).thenAnswer((_) => Future.delayed(
          Duration(milliseconds: 10), () => TestConstants.settings));

      final bloc = InitBloc(
        credentialsProvider: cp,
        settingsProvider: settingsWithDelay,
        topdeskProvider: tdp,
      );

      final actual = <InitState>[];
      final subscription = bloc.listen(actual.add);

      bloc.add(RequestInitData());

      /// Waiting for settings provider
      await Future.delayed(Duration(milliseconds: 50));

      await bloc.close();
      await subscription.cancel();

      expect(actual.length, 4);
      expect(actual.first, InitData.empty());
      expect(actual[1], InitData(credentials: TestConstants.credentials));
      expect(
          actual[2],
          InitData(
            credentials: TestConstants.credentials,
            currentOperator: TestConstants.currentOperator,
          ));
      expect(
        actual[3],
        InitData(
          credentials: TestConstants.credentials,
          currentOperator: TestConstants.currentOperator,
          settings: TestConstants.settings,
        ),
      );
    });

    test('RequestInitData equals', () {
      final e1 = RequestInitData();
      final e2 = RequestInitData();
      expect(e1 == e2, isTrue);
    });

    test('InitData toString contains info', () {
      final s = InitData(credentials: TestConstants.credentials);

      expect(s.toString().contains('Credentials'), isTrue);
    });

    test('isReady', () {
      expect(
        InitData(
          credentials: TestConstants.credentials,
          currentOperator: TestConstants.currentOperator,
          settings: TestConstants.settings,
        ).isReady(),
        isTrue,
      );

      expect(
        InitData(
          credentials: TestConstants.credentials,
          settings: TestConstants.settings,
        ).isReady(),
        isFalse,
      );
    });

    test('hasCompleteCredentials', () {
      expect(
        InitData(
          credentials: TestConstants.credentials,
        ).hasCompleteCredentials(),
        isTrue,
      );

      expect(
        InitData(
          credentials: Credentials(url: 'a'),
          settings: TestConstants.settings,
        ).hasCompleteCredentials(),
        isFalse,
      );
    });

    test('hasIncompleteCredentials', () {
      expect(
        InitData(
          credentials: TestConstants.credentials,
        ).hasIncompleteCredentials(),
        isFalse,
      );

      expect(InitData.empty().hasIncompleteCredentials(), isFalse);

      expect(
        InitData(
          credentials: Credentials(url: 'a'),
          settings: TestConstants.settings,
        ).hasIncompleteCredentials(),
        isTrue,
      );
    });

    test('hasCompleteSettings', () {
      expect(
        InitData(
          credentials: TestConstants.credentials,
        ).hasCompleteSettings(),
        isFalse,
      );

      expect(
        InitData(
          credentials: Credentials(url: 'a'),
          settings: TestConstants.settings,
        ).hasCompleteSettings(),
        isTrue,
      );

      expect(
        InitData(
          credentials: Credentials(url: 'a'),
          settings: Settings(tdBranchId: 'a'),
        ).hasCompleteSettings(),
        isFalse,
      );
    });

    test('hasIncompleteSettings', () {
      expect(
        InitData(
          credentials: TestConstants.credentials,
        ).hasIncompleteSettings(),
        isFalse,
      );

      expect(
        InitData(
          credentials: Credentials(url: 'a'),
          settings: TestConstants.settings,
        ).hasIncompleteSettings(),
        isFalse,
      );

      expect(
        InitData(
          credentials: Credentials(url: 'a'),
          settings: Settings(tdBranchId: 'a'),
        ).hasIncompleteSettings(),
        isTrue,
      );
    });

    group('errors', () {
      test('init fails', () async {
        final initFailsProvider = MockTopdeskProvider();
        final exc = SocketException('error test');
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

        bloc.add(RequestInitData());

        await bloc.close();
        await subscription.cancel();

        expect(actual.last, LoadingDataFailed(exc, null));
      });

      test('timeout', () async {
        final timeOutTdProvider = MockTopdeskProvider();
        when(timeOutTdProvider.init(any)).thenAnswer((_) => Future.value());

        final exc = TdTimeOutException('error test');
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

        bloc.add(RequestInitData());

        await bloc.close();
        await subscription.cancel();

        expect(actual.last, LoadingDataFailed(exc, null));
      });

      test(
          'TopdeskProvider gives error. Stream is closed. '
          'Settings are not added to closed stream', () async {
        final settingsWithDelay = MockSettingsProvider();
        when(settingsWithDelay.provide()).thenAnswer((_) => Future.delayed(
            Duration(milliseconds: 10), () => TestConstants.settings));

        final initFailsProvider = MockTopdeskProvider();
        final exc = SocketException('error test');
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

        bloc.add(RequestInitData());

        /// Waiting for settings provider
        await Future.delayed(Duration(milliseconds: 50));

        await bloc.close();
        await subscription.cancel();

        expect(actual.last, LoadingDataFailed(exc, null));
      });
    });
  });
}
