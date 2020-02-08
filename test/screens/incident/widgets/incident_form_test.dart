import 'dart:ui' as ui;

import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:toptodo/blocs/incident/bloc.dart';
import 'package:toptodo/screens/incident/widgets/incident_form.dart';
import 'package:toptodo/utils/keys.dart';
import 'package:toptodo_data/toptodo_data.dart';

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

class TestableWidgetWithMediaQuery extends StatelessWidget {
  const TestableWidgetWithMediaQuery({
    this.child,
    this.width,
    this.height,
  });

  final Widget child;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: MediaQuery(
          data: MediaQueryData.fromWindow(ui.window).copyWith(
            size: Size(width, height),
          ),
          child: child,
        ),
      ),
    );
  }
}
