import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:toptodo/blocs/login/bloc.dart';
import 'package:toptodo/screens/login/login_screen.dart';
import 'package:toptodo/screens/login/widgets/credentials_form.dart';
import 'package:toptodo/screens/login/widgets/login_help_dialog.dart';
import 'package:toptodo/constants/keys.dart' as ttd_keys;
import 'package:toptodo/widgets/error_dialog.dart';
import 'package:toptodo_data/toptodo_data.dart';

import '../../test_helper.dart';
import '../../test_constants.dart' as test_constants;

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

void main() {
  group('LoginScreen', () {
    LoginBloc bloc;

    void pumpScreen(
      WidgetTester tester, {
      bool logOut = false,
      Map<String, WidgetBuilder> routes,
    }) async {
      await tester.pumpWidget(
        BlocProvider.value(
          value: bloc,
          child: TestableWidgetWithMediaQuery(
            routes: routes,
            child: LoginScreen(logOut: logOut),
          ),
        ),
      );
    }

    setUp(() {
      bloc = MockLoginBloc();
    });

    tearDown(() {
      bloc.close();
    });

    testWidgets('WithCredentials shows filled form',
        (WidgetTester tester) async {
      when(bloc.state).thenReturn(RetrievedCredentials(
        test_constants.credentials,
        true,
      ));
      await pumpScreen(tester);

      expect(find.byType(CredentialsForm), findsOneWidget);
    });

    testWidgets('AwaitingCredentials shows CircularProgressIndicator',
        (WidgetTester tester) async {
      when(bloc.state).thenReturn(AwaitingCredentials());
      await pumpScreen(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('LoginSubmitting shows CircularProgressIndicator',
        (WidgetTester tester) async {
      when(bloc.state).thenReturn(LoginSubmitting());
      await pumpScreen(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('help button opens dialog', (WidgetTester tester) async {
      when(bloc.state).thenReturn(AwaitingCredentials());
      await pumpScreen(tester);

      final helpButton = find.byKey(Key(ttd_keys.loginScreenHelpButton));
      await tester.tap(helpButton);
      await tester.pump();
      expect(find.byType(LoginHelpDialog), findsOneWidget);
    });

    testWidgets('login success with complete settings navigates to incident',
        (WidgetTester tester) async {
      final initialState = AwaitingCredentials();
      when(bloc.state).thenReturn(initialState);
      whenListen(
        bloc,
        Stream.fromIterable(
          [
            initialState,
            LoginSuccess(settings: test_constants.settings),
          ],
        ),
      );

      await pumpScreen(
        tester,
        routes: {'incident': (_) => _TestScreen()},
      );
      await tester.pumpAndSettle();

      expect(find.byType(_TestScreen), findsOneWidget);
    });

    testWidgets('login success with incomplete settings navigates to settings',
        (WidgetTester tester) async {
      final initialState = AwaitingCredentials();
      when(bloc.state).thenReturn(initialState);
      whenListen(
        bloc,
        Stream.fromIterable(
          [
            initialState,
            LoginSuccess(settings: Settings()),
          ],
        ),
      );

      await pumpScreen(
        tester,
        routes: {'settings': (_) => _TestScreen()},
      );
      await tester.pumpAndSettle();

      expect(find.byType(_TestScreen), findsOneWidget);
    });

    testWidgets('login failed shows error dialog', (WidgetTester tester) async {
      final initialState = AwaitingCredentials();
      when(bloc.state).thenReturn(initialState);
      whenListen(
        bloc,
        Stream.fromIterable(
          [
            initialState,
            LoginFailed(
              savedData: test_constants.credentials,
              remember: true,
              cause: 'just testing',
              stackTrace: StackTrace.current,
            ),
          ],
        ),
      );

      await pumpScreen(tester);
      await tester.pumpAndSettle();

      expect(find.byType(ErrorDialog), findsOneWidget);
    });
  });
}

class _TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container();
}
