import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:toptodo/blocs/incident/bloc.dart';
import 'package:toptodo/screens/incident/widgets/incident_form.dart';
import 'package:toptodo/utils/keys.dart';
import 'package:toptodo_data/toptodo_data.dart';

import '../../../helper.dart';

class MockIncidentBloc extends MockBloc<IncidentEvent, IncidentState>
    implements IncidentBloc {}

void main() {
  group('IncidentForm', () {
    final currentOperator = TdOperator(
      id: 'a',
      name: 'a',
      firstLine: true,
      secondLine: true,
    );

    IncidentBloc bloc;

    void pumpForm(
      WidgetTester tester,
      IncidentState state,
    ) async {
      await tester.pumpWidget(
        BlocProvider.value(
          value: bloc,
          child: TestableWidgetWithMediaQuery(
            width: 800,
            height: 600,
            child: IncidentForm(state),
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

    testWidgets('find one button when not submitting',
        (WidgetTester tester) async {
      await pumpForm(
        tester,
        IncidentState(
          currentOperator: currentOperator,
        ),
      );
      expect(find.byKey(TtdKeys.incidentSubmitButton), findsOneWidget);
    });

    testWidgets('find no button when submitting', (WidgetTester tester) async {
      await pumpForm(
        tester,
        IncidentSubmitted(
          currentOperator: currentOperator,
        ),
      );
      expect(find.byKey(TtdKeys.incidentSubmitButton), findsNothing);
    });

    testWidgets('tap button', (WidgetTester tester) async {
      when(bloc.state).thenReturn(IncidentState(currentOperator: null));
      await pumpForm(
        tester,
        IncidentState(
          currentOperator: currentOperator,
        ),
      );

      await tester.enterText(
        find.byKey(TtdKeys.incidentBriefDescriptionField),
        'todo',
      );
      await tester.enterText(
        find.byKey(TtdKeys.incidentRequestField),
        'more text',
      );
      await tester.tap(find.byKey(TtdKeys.incidentSubmitButton));
      await tester.pumpAndSettle();

      verify(bloc.add(
        IncidentSubmit(
          briefDescription: 'todo',
          request: 'more text',
        ),
      ));
    });
  });
}
