import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:toptodo/blocs/settings/bloc.dart';
import 'package:toptodo/screens/settings/settings_screen.dart';
import 'package:toptodo/screens/settings/widgets/settings_form.dart';
import 'package:toptodo/widgets/error_dialog.dart';
import 'package:toptodo/widgets/menu_operator_button.dart';

import '../../test_constants.dart' as ttd_constants;
import '../../test_helper.dart';

class MockSettingsBloc extends MockBloc<SettingsEvent, SettingsState>
    implements SettingsBloc {}

void main() {
  group('SettingsScreen', () {
    SettingsBloc bloc;

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
            child: SettingsScreen(),
          ),
        ),
      );
    }

    setUp(() {
      bloc = MockSettingsBloc();
    });

    testWidgets('initial state shows CircularProgressIndicator',
        (WidgetTester tester) async {
      when(bloc.state).thenReturn(InitialSettingsState());
      await pumpScreen(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(MenuOperatorButton), findsNothing);
    });

    testWidgets('SettingsWithForm shows SettingsForm',
        (WidgetTester tester) async {
      when(bloc.state).thenReturn(UpdatedSettingsForm(
        currentOperator: ttd_constants.currentOperator,
        formState: SettingsFormState(),
      ));
      await pumpScreen(tester);

      expect(find.byType(SettingsForm), findsOneWidget);
      expect(find.byType(MenuOperatorButton), findsOneWidget);
    });

    testWidgets('show error dialog', (WidgetTester tester) async {
      final initialState = InitialSettingsState();
      when(bloc.state).thenReturn(initialState);
      whenListen(
        bloc,
        Stream.fromIterable(
          [
            initialState,
            SettingsError('just testing', StackTrace.current),
          ],
        ),
      );

      await pumpScreen(tester);
      await tester.pump();

      expect(find.byType(ErrorDialog), findsOneWidget);
    });

    testWidgets('saved settings navigates to incident',
        (WidgetTester tester) async {
      final initialState = InitialSettingsState();
      when(bloc.state).thenReturn(initialState);
      whenListen(
        bloc,
        Stream.fromIterable(
          [
            initialState,
            SettingsSaved(
              formState: SettingsFormState(),
              currentOperator: ttd_constants.currentOperator,
            ),
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
  });
}

class _TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container();
}
