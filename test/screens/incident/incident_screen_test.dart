import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:toptodo_data/toptodo_data.dart';

import 'package:toptodo/blocs/incident/bloc.dart';
import 'package:toptodo/screens/incident/incident_screen.dart';
import 'package:toptodo/screens/incident/widgets/incident_form.dart';
import 'package:toptodo/widgets/menu_operator_button.dart';

import '../../helper.dart';

const incidentCreatedState = IncidentCreated(
  currentOperator: null,
  number: '123',
);

const withOperatorState = IncidentState(
  currentOperator: TdOperator(
    id: 'a',
    name: 'a',
    firstLine: true,
    secondLine: true,
  ),
);

class NeedOperator extends IncidentEvent {}

class SimpleIncidentBloc extends IncidentBloc {
  @override
  Stream<IncidentState> mapEventToState(IncidentEvent event) async* {
    if (event is NeedOperator) {
      yield withOperatorState;
    } else if (event is IncidentSubmit) {
      yield incidentCreatedState;
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
      bloc = SimpleIncidentBloc();
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
        bloc.add(NeedOperator());
        await Future.delayed(Duration(milliseconds: 100));

        await pumpScreen(tester);
        expect(find.byType(MenuOperatorButton), findsOneWidget);
      });
    });

    testWidgets('show snackbar after incident created', (tester) async {
      await tester.runAsync(() async {
        await pumpScreen(tester);
        bloc.add(IncidentSubmit(briefDescription: '', request: ''));

        await Future.delayed(Duration(milliseconds: 100));
        await tester.pump();
        expect(find.text('Incident created with number 123'), findsOneWidget);
      });
    });
  });
}
