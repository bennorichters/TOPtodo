import 'package:test/test.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:toptodo/blocs/login/bloc.dart';
import 'package:toptodo_data/toptodo_data.dart';

class MockCredentialsProvider extends Mock implements CredentialsProvider {}

class MockSettingsProvider extends Mock implements SettingsProvider {}

class MockTopdeskProvider extends Mock implements TopdeskProvider {}

void main() {
  group('login bloc', () {
    CredentialsProvider withoutCredentials = MockCredentialsProvider();
    when(withoutCredentials.provide())
        .thenAnswer((_) => Future.value(Credentials()));

    final credentials = Credentials(
      url: 'https://your-environment.topdesk.net',
      loginName: 'usera',
      password: 'S3CrEt!',
    );
    CredentialsProvider withCredentials = MockCredentialsProvider();
    when(withCredentials.provide())
        .thenAnswer((_) => Future.value(credentials));

    group('basic flow', () {
      blocTest<LoginBloc, LoginEvent, LoginState>(
        'emits [LoginWaitingForSavedDate] for initial state',
        build: () => LoginBloc(
          credentialsProvider: withoutCredentials,
          settingsProvider: MockSettingsProvider(),
          topdeskProvider: MockTopdeskProvider(),
        ),
        expect: [LoginWaitingForSavedData()],
      );

      blocTest<LoginBloc, LoginEvent, LoginState>(
        'CredentialsInit - no data - dont remember '
        'user has to explicitly give consent to remember',
        build: () => LoginBloc(
          credentialsProvider: withoutCredentials,
          settingsProvider: MockSettingsProvider(),
          topdeskProvider: MockTopdeskProvider(),
        ),
        act: (LoginBloc bloc) async => bloc.add(CredentialsInit()),
        expect: [
          LoginWaitingForSavedData(),
          RetrievedSavedData(Credentials(), false),
        ],
      );

      blocTest<LoginBloc, LoginEvent, LoginState>(
        'CredentialsInit - with data - remember '
        'user in the past has given explicit consent to remember',
        build: () => LoginBloc(
          credentialsProvider: withCredentials,
          settingsProvider: MockSettingsProvider(),
          topdeskProvider: MockTopdeskProvider(),
        ),
        act: (LoginBloc bloc) async => bloc.add(CredentialsInit()),
        expect: [
          LoginWaitingForSavedData(),
          RetrievedSavedData(credentials, true),
        ],
      );

      blocTest<LoginBloc, LoginEvent, LoginState>(
        'toggle remember',
        build: () => LoginBloc(
          credentialsProvider: withoutCredentials,
          settingsProvider: MockSettingsProvider(),
          topdeskProvider: MockTopdeskProvider(),
        ),
        act: (LoginBloc bloc) async => bloc.add(
          RememberToggle(
            Credentials(
              url: 'a',
              loginName: 'b',
              password: 'c',
            ),
          ),
        ),
        expect: [
          LoginWaitingForSavedData(),
          RetrievedSavedData(
            Credentials(
              url: 'a',
              loginName: 'b',
              password: 'c',
            ),
            true,
          ),
        ],
      );

      test('toggle remember to false deletes credentials', () async {
        final TopdeskProvider topdeskProvider = MockTopdeskProvider();
        final SettingsProvider settingsProvider = MockSettingsProvider();

        final bloc = LoginBloc(
          credentialsProvider: withCredentials,
          settingsProvider: settingsProvider,
          topdeskProvider: topdeskProvider,
        );

        bloc.add(CredentialsInit());
        final userEnteredCredentials = Credentials(
          url: 'a',
          loginName: 'b',
          password: 'c',
        );
        bloc.add(RememberToggle(userEnteredCredentials));

        await emitsExactly<LoginBloc, LoginState>(
          bloc,
          [
            LoginWaitingForSavedData(),
            RetrievedSavedData(credentials, true),
            RetrievedSavedData(userEnteredCredentials, false),
          ],
        );

        verify(withCredentials.delete()).called(1);
      });

      test('log out', () async {
        final TopdeskProvider topdeskProvider = MockTopdeskProvider();
        final SettingsProvider settingsProvider = MockSettingsProvider();

        final bloc = LoginBloc(
          credentialsProvider: withCredentials,
          settingsProvider: settingsProvider,
          topdeskProvider: topdeskProvider,
        );

        bloc.add(CredentialsInit());
        bloc.add(LogOut());

        await emitsExactly<LoginBloc, LoginState>(
          bloc,
          [
            LoginWaitingForSavedData(),
            RetrievedSavedData(credentials, true),
            LoginWaitingForSavedData(),
            RetrievedSavedData(Credentials(), false),
          ],
        );

        verify(withCredentials.delete()).called(1);
      });

      test(
          'remember flag true when entering loginscreen with saved credentials',
          () async {
        final TopdeskProvider topdeskProvider = MockTopdeskProvider();
        final SettingsProvider settingsProvider = MockSettingsProvider();

        final bloc = LoginBloc(
          credentialsProvider: withCredentials,
          settingsProvider: settingsProvider,
          topdeskProvider: topdeskProvider,
        );

        bloc.add(CredentialsInit());

        await emitsExactly<LoginBloc, LoginState>(
          bloc,
          [LoginWaitingForSavedData(), RetrievedSavedData(credentials, true)],
        );
      });
    });

    group('TryLogin', () {
      final topdeskProvider = MockTopdeskProvider();
      final SettingsProvider completeSettings = MockSettingsProvider();
      final settings = Settings(
        tdBranchId: 'a',
        tdCallerId: 'a',
        tdCategoryId: 'a',
        tdSubcategoryId: 'a',
        tdDurationId: 'a',
        tdOperatorId: 'a',
      );
      when(completeSettings.provide()).thenAnswer(
        (_) => Future<Settings>.value(settings),
      );

      test(
          'valid settings - no prior credentials '
          'no consent to remember - dont save', () async {
        final bloc = LoginBloc(
          credentialsProvider: withoutCredentials,
          settingsProvider: completeSettings,
          topdeskProvider: topdeskProvider,
        );

        bloc.add(CredentialsInit());
        bloc.add(TryLogin(credentials));

        await emitsExactly<LoginBloc, LoginState>(
          bloc,
          [
            LoginWaitingForSavedData(),
            RetrievedSavedData(Credentials(), false),
            LoginSubmitting(),
            LoginSuccessValidSettings(
              topdeskProvider: topdeskProvider,
              settings: settings,
            ),
          ],
        );

        verifyNever(withCredentials.save(any));
      });

      test(
          'valid settings - no prior credentials '
          'toggled to remember - save', () async {
        final bloc = LoginBloc(
          credentialsProvider: withoutCredentials,
          settingsProvider: completeSettings,
          topdeskProvider: topdeskProvider,
        );

        bloc.add(CredentialsInit());
        bloc.add(RememberToggle(credentials));
        bloc.add(TryLogin(credentials));

        await emitsExactly<LoginBloc, LoginState>(
          bloc,
          [
            LoginWaitingForSavedData(),
            RetrievedSavedData(Credentials(), false),
            RetrievedSavedData(credentials, true),
            LoginSubmitting(),
            LoginSuccessValidSettings(
              topdeskProvider: topdeskProvider,
              settings: settings,
            ),
          ],
        );

        verify(withoutCredentials.save(credentials)).called(1);
      });

      test('incomplete settings', () async {
        final saved = Settings(
          tdBranchId: 'a',
          tdCallerId: 'a',
          tdCategoryId: 'a',
          tdSubcategoryId: 'a',
          tdDurationId: 'a',
          tdOperatorId: null,
        );

        final incomplete = Settings(
          tdBranchId: 'a',
          tdCallerId: 'a',
          tdCategoryId: 'a',
          tdSubcategoryId: 'a',
          tdDurationId: 'a',
          tdOperatorId: null,
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

        bloc.add(TryLogin(credentials));

        await emitsExactly<LoginBloc, LoginState>(
          bloc,
          [
            LoginWaitingForSavedData(),
            LoginSubmitting(),
            LoginSuccessIncompleteSettings(
              topdeskProvider: topdeskProvider,
              settings: incomplete,
            ),
          ],
        );
      });
    });

    group('TryLogin errors', () {
      final credentials = Credentials(
        url: 'a',
        loginName: 'userA',
        password: 'S3CrEt!',
      );

      Future<void> testException(Exception e) async {
        final topdeskProvider = MockTopdeskProvider();
        when(topdeskProvider.currentTdOperator()).thenThrow(e);

        final bloc = LoginBloc(
          credentialsProvider: MockCredentialsProvider(),
          settingsProvider: MockSettingsProvider(),
          topdeskProvider: topdeskProvider,
        );

        bloc.add(TryLogin(credentials));

        await emitsExactly<LoginBloc, LoginState>(
          bloc,
          <dynamic>[
            LoginWaitingForSavedData(),
            LoginSubmitting(),
            isA<LoginFailed>(),
          ],
        );
      }

      test('not authorized', () async {
        await testException(TdNotAuthorizedException(''));
      });

      test('time out', () async {
        await testException(const TdTimeOutException(''));
      });

      test('time out', () async {
        await testException(const TdServerException(''));
      });
    });
  });
}
