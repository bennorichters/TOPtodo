import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:toptodo/blocs/incident/bloc.dart';
import 'package:toptodo/screens/incident/incident_screen.dart';
import 'package:toptodo/screens/incident/widgets/incident_form.dart';
import 'package:toptodo/widgets/error_dialog.dart';
import 'package:toptodo/widgets/menu_operator_button.dart';

import '../../helper.dart';

class MockIncidentBloc extends MockBloc<IncidentEvent, IncidentState>
    implements IncidentBloc {}

void main() {
  group('IncidentScreen', () {
    IncidentBloc bloc;

    void pumpScreen(
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        BlocProvider.value(
          value: bloc,
          child: TestableWidgetWithMediaQuery(
            child: IncidentScreen(),
          ),
        ),
      );
    }

    setUp(() {
      bloc = MockIncidentBloc();
    });

    tearDown(() {
      bloc.close();
    });

    testWidgets('current operator is null', (WidgetTester tester) async {
      when(bloc.state).thenReturn(IncidentState(currentOperator: null));

      await pumpScreen(tester);

      expect(find.byType(MenuOperatorButton), findsNothing);
      expect(find.byType(IncidentForm), findsOneWidget);
    });

    testWidgets('with current operator', (WidgetTester tester) async {
      when(bloc.state).thenReturn(IncidentState(
        currentOperator: TestConstants.currentOperator,
      ));

      await pumpScreen(tester);
      expect(find.byType(MenuOperatorButton), findsOneWidget);
    });

    testWidgets('show snackbar after incident created', (tester) async {
      final initialState = IncidentState(currentOperator: null);
      when(bloc.state).thenReturn(initialState);
      whenListen(
        bloc,
        Stream.fromIterable(
          [
            initialState,
            IncidentCreated(number: '123', currentOperator: null),
          ],
        ),
      );

      await pumpScreen(tester);

      await tester.pump();
      expect(find.text('Incident created with number 123'), findsOneWidget);
    });

    testWidgets('show error dialog after error', (tester) async {
      final initialState = IncidentState(currentOperator: null);
      when(bloc.state).thenReturn(initialState);
      whenListen(
        bloc,
        Stream.fromIterable(
          [
            initialState,
            IncidentCreationError(
              currentOperator: null,
              cause: 'just testing',
              stackTrace: StackTrace.current,
            ),
          ],
        ),
      );

      await pumpScreen(tester);

      await tester.pump();
      expect(find.byType(ErrorDialog), findsOneWidget);
    });
  });
}
