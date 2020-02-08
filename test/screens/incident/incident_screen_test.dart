import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:toptodo/blocs/incident/bloc.dart';
import 'package:toptodo/screens/incident/incident_screen.dart';
import 'package:toptodo/screens/incident/widgets/incident_form.dart';
import 'package:toptodo/widgets/menu_operator_button.dart';
import 'package:toptodo_data/toptodo_data.dart';

import '../../helper.dart';

class MockIncidentBloc extends MockBloc<IncidentEvent, IncidentState>
    implements IncidentBloc {}

void main() {
  group('IncidentScreen', () {
    final currentOperator = TdOperator(
      id: 'a',
      name: 'a',
      firstLine: true,
      secondLine: true,
    );

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
      when(bloc.state).thenReturn(IncidentState(currentOperator: currentOperator));

      await pumpScreen(tester);

      expect(find.byType(MenuOperatorButton), findsOneWidget);
      expect(find.byType(IncidentForm), findsOneWidget);
    });
  });
}
