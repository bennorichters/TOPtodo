import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:toptodo/blocs/login/bloc.dart';
import 'package:toptodo/screens/login/login_screen.dart';
import 'package:toptodo/screens/login/widgets/login_help_dialog.dart';
import 'package:toptodo/utils/keys.dart';

import '../../helper.dart';

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

void main() {
  group('LoginScreen', () {
    LoginBloc bloc;

    void pumpScreen(
      WidgetTester tester,
      bool logOut,
    ) async {
      await tester.pumpWidget(
        BlocProvider.value(
          value: bloc,
          child: TestableWidgetWithMediaQuery(
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

    testWidgets('AwaitingCredentials shows CircularProgressIndicator',
        (WidgetTester tester) async {
      when(bloc.state).thenReturn(AwaitingCredentials());
      await pumpScreen(tester, false);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('help button opens dialog', (WidgetTester tester) async {
      when(bloc.state).thenReturn(AwaitingCredentials());
      await pumpScreen(tester, false);

      final helpButton = find.byKey(Key(TtdKeys.loginScreenHelpButton));
      await tester.tap(helpButton);
      await tester.pump();
      expect(find.byType(LoginHelpDialog), findsOneWidget);
    });
  });
}
