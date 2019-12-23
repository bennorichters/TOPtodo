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
      act: (LoginBloc bloc) async => bloc.add(const RememberToggle()),
      expect: <LoginState>[
        const LoginWaitingForSavedData(),
        const RetrievedSavedData(null, true),
      ],
    );
  });

  group('TryLogin', () {
    const branchA = Branch(id: 'a', name: 'A');
    const branchB = Branch(id: 'b', name: 'B');
    const callerA = Caller(
      id: 'a',
      name: 'CallerA',
      avatar: 'avatarA',
      branch: branchA,
    );
    const categoryA = Category(id: 'a', name: 'A');
    const categoryB = Category(id: 'b', name: 'B');
    const subCategoryA = SubCategory(
      id: 'a',
      name: 'SubCatA',
      category: categoryA,
    );
    const durationA = IncidentDuration(id: 'a', name: 'A');
    const operatorA = IncidentOperator(
      id: 'a',
      name: 'A',
      avatar: 'avatarOpA',
    );

    final TopdeskProvider tdp = MockTopdeskProvider();
    when(tdp.caller(id: 'a')).thenAnswer(
      (_) => Future<Caller>.value(callerA),
    );
    when(tdp.caller(id: 'b')).thenAnswer(
      (_) => Future<Caller>.value(
        const Caller(
          id: 'b',
          name: 'CallerB',
          avatar: 'avatarB',
          branch: branchB,
        ),
      ),
    );
    when(tdp.subCategory(id: 'a')).thenAnswer(
      (_) => Future<SubCategory>.value(subCategoryA),
    );
    when(tdp.subCategory(id: 'b')).thenAnswer(
      (_) => Future<SubCategory>.value(
        const SubCategory(id: 'b', name: 'SubCatB', category: categoryB),
      ),
    );

    const credentials = Credentials(
      url: 'a',
      loginName: 'userA',
      password: 'S3CrEt!',
    );

    test('valid settings', () async {
      final SettingsProvider settingsProvider = MockSettingsProvider();

      final bloc = LoginBloc(
        credentialsProvider: MockCredentialsProvider(),
        settingsProvider: settingsProvider,
        topdeskProvider: tdp,
      );

      const settings = Settings(
        branch: branchA,
        caller: callerA,
        category: categoryA,
        subCategory: subCategoryA,
        incidentDuration: durationA,
        incidentOperator: operatorA,
      );
      when(settingsProvider.provide()).thenAnswer(
        (_) => Future<Settings>.value(settings),
      );

      bloc.add(const TryLogin(credentials));

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
      const saved = Settings(
        branch: branchA,
        caller: callerA,
        category: categoryA,
        subCategory: subCategoryA,
        incidentDuration: durationA,
        incidentOperator: null,
      );

      const incomplete = Settings(
        branch: branchA,
        caller: callerA,
        category: categoryA,
        subCategory: subCategoryA,
        incidentDuration: durationA,
        incidentOperator: null,
      );

      final SettingsProvider settingsProvider = MockSettingsProvider();

      final bloc = LoginBloc(
        credentialsProvider: MockCredentialsProvider(),
        settingsProvider: settingsProvider,
        topdeskProvider: tdp,
      );

      when(settingsProvider.provide()).thenAnswer(
        (_) => Future<Settings>.value(saved),
      );

      bloc.add(const TryLogin(credentials));

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
