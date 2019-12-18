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
  });

  group('TryLogin', () {
    final TopdeskProvider tdp = MockTopdeskProvider();
    when(tdp.caller(id: 'a')).thenAnswer(
      (_) => Future<Caller>.value(
        Caller.fromJson(const <String, String>{
          'id': 'a',
          'name': 'CallerA',
          'branchId': 'a',
        }),
      ),
    );
    when(tdp.caller(id: 'b')).thenAnswer(
      (_) => Future<Caller>.value(
        Caller.fromJson(const <String, String>{
          'id': 'b',
          'name': 'CallerB',
          'branchId': 'b',
        }),
      ),
    );
    when(tdp.subCategory(id: 'a')).thenAnswer(
      (_) => Future<SubCategory>.value(
        SubCategory.fromJson(const <String, String>{
          'id': 'a',
          'name': 'SubCatA',
          'categoryId': 'a',
        }),
      ),
    );
    when(tdp.subCategory(id: 'b')).thenAnswer(
      (_) => Future<SubCategory>.value(
        SubCategory.fromJson(const <String, String>{
          'id': 'b',
          'name': 'SubCatB',
          'categoryId': 'b',
        }),
      ),
    );

    final SettingsProvider settingsProvider = MockSettingsProvider();

    final LoginBloc bloc = LoginBloc(
      credentialsProvider: MockCredentialsProvider(),
      settingsProvider: settingsProvider,
      topdeskProvider: tdp,
    );

    final Credentials credentials = Credentials(
      url: 'a',
      loginName: 'userA',
      password: 'S3CrEt!',
    );

    loginInvalidSettings(Settings saved, Settings incomplete) async {
      when(settingsProvider.provide()).thenAnswer(
        (_) => Future<Settings>.value(saved),
      );

      bloc.add(TryLogin(credentials));

      await emitsExactly<LoginBloc, LoginState>(
        bloc,
        <LoginState>[
          const LoginWaitingForSavedData(),
          const LoginSubmitting(),
          LoginSuccessIncompleteSettings(
            topdeskProvider: tdp,
            settings: incomplete,
          ),
        ],
      );
    }

    test('valid settings', () async {
      const Settings settings = Settings(
        branchId: 'a',
        callerId: 'a',
        categoryId: 'a',
        subcategoryId: 'a',
        incidentDurationId: 'a',
        incidentOperatorId: 'a',
      );
      when(settingsProvider.provide()).thenAnswer(
        (_) => Future<Settings>.value(settings),
      );

      bloc.add(TryLogin(credentials));

      await emitsExactly<LoginBloc, LoginState>(
        bloc,
        <LoginState>[
          const LoginWaitingForSavedData(),
          const LoginSubmitting(),
          LoginSuccessValidSettings(
            topdeskProvider: tdp,
            settings: settings,
          ),
        ],
      );
    });

    test('incomplete settings', () async {
      loginInvalidSettings(
        const Settings(
          branchId: 'a',
          callerId: 'a',
          categoryId: 'a',
          subcategoryId: 'a',
          incidentDurationId: 'a',
          incidentOperatorId: null,
        ),
        const Settings(
          branchId: 'a',
          callerId: 'a',
          categoryId: 'a',
          subcategoryId: 'a',
          incidentDurationId: 'a',
          incidentOperatorId: null,
        ),
      );
    });

    test('invalid settings caller belongs to other branch', () async {
      loginInvalidSettings(
        const Settings(
          branchId: 'a',
          callerId: 'b',
          categoryId: 'a',
          subcategoryId: 'a',
          incidentDurationId: 'a',
          incidentOperatorId: 'a',
        ),
        const Settings(
          branchId: 'a',
          callerId: null,
          categoryId: 'a',
          subcategoryId: 'a',
          incidentDurationId: 'a',
          incidentOperatorId: 'a',
        ),
      );
    });

    test('invalid settings sub category belongs to other category', () async {
      loginInvalidSettings(
        const Settings(
          branchId: 'a',
          callerId: 'a',
          categoryId: 'a',
          subcategoryId: 'b',
          incidentDurationId: 'a',
          incidentOperatorId: 'a',
        ),
        const Settings(
          branchId: 'a',
          callerId: 'a',
          categoryId: 'a',
          subcategoryId: null,
          incidentDurationId: 'a',
          incidentOperatorId: 'a',
        ),
      );
    });

    test('incomplete and invalid settings', () async {
      loginInvalidSettings(
        const Settings(
          branchId: 'a',
          callerId: 'b',
          categoryId: 'a',
          subcategoryId: 'a',
          incidentDurationId: 'a',
          incidentOperatorId: null,
        ),
        const Settings(
          branchId: 'a',
          callerId: null,
          categoryId: 'a',
          subcategoryId: 'a',
          incidentDurationId: 'a',
          incidentOperatorId: null,
        ),
      );
    });
  });
}
