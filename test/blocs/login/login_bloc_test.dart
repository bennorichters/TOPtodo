import 'package:flutter_test/flutter_test.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:toptodo/blocs/login/bloc.dart';
import 'package:toptodo_data/toptodo_data.dart';

// class MockLoginBloc extends MockBloc<LoginEvent, LoginState> implements LoginBloc {}

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
      expect: <LoginState>[const LoginWaitingForSavedData()],
    );

    blocTest<LoginBloc, LoginEvent, LoginState>(
      '...',
      build: () => LoginBloc(
        credentialsProvider: MockCredentialsProvider(),
        settingsProvider: MockSettingsProvider(),
        topdeskProvider: MockTopdeskProvider(),
      ),
      act: (LoginBloc bloc) async => bloc.add(const RememberToggle(null, true)),
      expect: <LoginState>[
        const LoginWaitingForSavedData(),
        const RetrievedSavedData(null, true),
      ],
    );

    test('Login without settings', () async {
      final TopdeskProvider tdp = MockTopdeskProvider();
      final LoginBloc bloc = LoginBloc(
        credentialsProvider: MockCredentialsProvider(),
        settingsProvider: MockSettingsProvider(),
        topdeskProvider: tdp,
      );

      final Credentials credentials = Credentials(
        url: 'a',
        loginName: 'userA',
        password: 'S3CrEt!',
      );

      bloc.add(TryLogin(credentials));

      await emitsExactly<LoginBloc, LoginState>(
        bloc,
        <LoginState>[
          const LoginWaitingForSavedData(),
          const LoginSubmitting(),
          LoginSuccessNoSettings(topdeskProvider: tdp),
        ],
      );
    });
  });
}
