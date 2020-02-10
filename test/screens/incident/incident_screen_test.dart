import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:toptodo/widgets/error_dialog.dart';

import 'package:toptodo_data/toptodo_data.dart';

import 'package:toptodo/blocs/incident/bloc.dart';
import 'package:toptodo/screens/incident/incident_screen.dart';
import 'package:toptodo/screens/incident/widgets/incident_form.dart';
import 'package:toptodo/widgets/menu_operator_button.dart';

import '../../helper.dart';

class _TriggerCreateIncident extends IncidentEvent {}

class _TriggerError extends IncidentEvent {}

class _TriggerOperator extends IncidentEvent {}

class _SimpleIncidentBloc extends IncidentBloc {
  @override
  Stream<IncidentState> mapEventToState(IncidentEvent event) async* {
    if (event is _TriggerCreateIncident) {
      yield const IncidentCreated(
        currentOperator: null,
        number: '123',
      );
    } else if (event is _TriggerError) {
      yield IncidentCreationError(
        cause: 'just testing',
        stackTrace: StackTrace.current,
        currentOperator: null,
      );
    } else if (event is _TriggerOperator) {
      yield const IncidentState(
        currentOperator: TdOperator(
          id: 'a',
          name: 'a',
          firstLine: true,
          secondLine: true,
        ),
      );
    }
  }
}

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
            width: 800,
            height: 600,
            child: IncidentScreen(),
          ),
        ),
      );
    }

    setUp(() {
      bloc = _SimpleIncidentBloc();
    });

    tearDown(() {
      bloc.close();
    });

    testWidgets('current operator is null', (WidgetTester tester) async {
      await pumpScreen(tester);

      expect(find.byType(MenuOperatorButton), findsNothing);
      expect(find.byType(IncidentForm), findsOneWidget);
    });

    testWidgets('with current operator', (WidgetTester tester) async {
      await tester.runAsync(() async {
        bloc.add(_TriggerOperator());
        await Future.delayed(Duration(milliseconds: 100));

        await pumpScreen(tester);
        expect(find.byType(MenuOperatorButton), findsOneWidget);
      });
    });

    testWidgets('show snackbar after incident created', (tester) async {
      await tester.runAsync(() async {
        await pumpScreen(tester);
        bloc.add(_TriggerCreateIncident());

        await Future.delayed(Duration(milliseconds: 100));
        await tester.pump();
        expect(find.text('Incident created with number 123'), findsOneWidget);
      });
    });

    testWidgets('show error dialog after error', (tester) async {
      await tester.runAsync(() async {
        await pumpScreen(tester);
        bloc.add(_TriggerError());

        await Future.delayed(Duration(milliseconds: 100));
        await tester.pump();
        expect(find.byType(ErrorDialog), findsOneWidget);
      });
    });
  });
}
