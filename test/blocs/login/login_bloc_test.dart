import 'package:test/test.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:toptodo/blocs/login/bloc.dart';
import 'package:toptodo_data/toptodo_data.dart';

class MockCredentialsProvider extends Mock implements CredentialsProvider {}

class MockSettingsProvider extends Mock implements SettingsProvider {}

class MockTopdeskProvider extends Mock implements TopdeskProvider {}

void main() {
  group('basic flow', () {
    blocTest<LoginBloc, LoginEvent, LoginState>(
      'emits [LoginWaitingForSavedDate] for initial state',
      build: () => LoginBloc(
        credentialsProvider: MockCredentialsProvider(),
        settingsProvider: MockSettingsProvider(),
        topdeskProvider: MockTopdeskProvider(),
      ),
      expect: [const LoginWaitingForSavedData()],
    );

    blocTest<LoginBloc, LoginEvent, LoginState>(
      'toggle remember',
      build: () => LoginBloc(
        credentialsProvider: MockCredentialsProvider(),
        settingsProvider: MockSettingsProvider(),
        topdeskProvider: MockTopdeskProvider(),
      ),
      act: (LoginBloc bloc) async => bloc.add(
        const RememberToggle(
          Credentials(
            url: 'a',
            loginName: 'b',
            password: 'c',
          ),
        ),
      ),
      expect: [
        const LoginWaitingForSavedData(),
        const RetrievedSavedData(
          Credentials(
            url: 'a',
            loginName: 'b',
            password: 'c',
          ),
          true,
        ),
      ],
    );
  });

  group('TryLogin', () {
    const credentials = Credentials(
      url: 'a',
      loginName: 'userA',
      password: 'S3CrEt!',
    );

    test('valid settings', () async {
      final TopdeskProvider topdeskProvider = MockTopdeskProvider();
      final SettingsProvider settingsProvider = MockSettingsProvider();

      final bloc = LoginBloc(
        credentialsProvider: MockCredentialsProvider(),
        settingsProvider: settingsProvider,
        topdeskProvider: topdeskProvider,
      );

      const settings = Settings(
        tdBranchId: 'a',
        tdCallerId: 'a',
        tdCategoryId: 'a',
        tdSubcategoryId: 'a',
        tdDurationId: 'a',
        tdOperatorId: 'a',
      );
      when(settingsProvider.provide()).thenAnswer(
        (_) => Future<Settings>.value(settings),
      );

      bloc.add(const TryLogin(credentials));

      await emitsExactly<LoginBloc, LoginState>(
        bloc,
        [
          const LoginWaitingForSavedData(),
          const LoginSubmitting(),
          LoginSuccessValidSettings(
            topdeskProvider: topdeskProvider,
            settings: settings,
          ),
        ],
      );
    });

    test('incomplete settings', () async {
      const saved = Settings(
        tdBranchId: 'a',
        tdCallerId: 'a',
        tdCategoryId: 'a',
        tdSubcategoryId: 'a',
        tdDurationId:  'a',
        tdOperatorId:  null,
      );

      const incomplete = Settings(
        tdBranchId: 'a',
        tdCallerId: 'a',
        tdCategoryId: 'a',
        tdSubcategoryId: 'a',
        tdDurationId:  'a',
        tdOperatorId:  null,
      );

      final TopdeskProvider topdeskProvider = MockTopdeskProvider();
      final SettingsProvider settingsProvider = MockSettingsProvider();

      final bloc = LoginBloc(
        credentialsProvider: MockCredentialsProvider(),
        settingsProvider: settingsProvider,
        topdeskProvider: topdeskProvider,
      );

      when(settingsProvider.provide()).thenAnswer(
        (_) => Future<Settings>.value(saved),
      );

      bloc.add(const TryLogin(credentials));

      await emitsExactly<LoginBloc, LoginState>(
        bloc,
        [
          const LoginWaitingForSavedData(),
          const LoginSubmitting(),
          LoginSuccessIncompleteSettings(
            topdeskProvider: topdeskProvider,
            settings: incomplete,
          ),
        ],
      );
    });
  });

  group('TryLogin errors', () {
    const credentials = Credentials(
      url: 'a',
      loginName: 'userA',
      password: 'S3CrEt!',
    );

    Future<void> testException(Exception e) async {
      final SettingsProvider sp = MockSettingsProvider();
      when(sp.provide()).thenThrow(e);

      final bloc = LoginBloc(
        credentialsProvider: MockCredentialsProvider(),
        settingsProvider: sp,
        topdeskProvider: MockTopdeskProvider(),
      );

      bloc.add(const TryLogin(credentials));

      await emitsExactly<LoginBloc, LoginState>(
        bloc,
        <dynamic>[
          const LoginWaitingForSavedData(),
          const LoginSubmitting(),
          isA<LoginFailed>(),
        ],
      );
    }

    test('not authorized', () async {
      await testException(const TdNotAuthorizedException(''));
    });

    test('time out', () async {
      await testException(const TdTimeOutException(''));
    });

    test('time out', () async {
      await testException(const TdServerException(''));
    });
  });
}
