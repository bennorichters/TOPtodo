import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:toptodo/blocs/incident/bloc.dart';
import 'package:toptodo/screens/incident/widgets/incident_form.dart';
import 'package:toptodo/widgets/td_button.dart';
import 'package:toptodo_data/toptodo_data.dart';

void main() {
  group('IncidentForm', () {
    final currentOperator = TdOperator(
      id: 'a',
      name: 'a',
      firstLine: true,
      secondLine: true,
    );

    Future<Finder> buttonFinder(
      WidgetTester tester,
      IncidentState state,
    ) async {
      await tester.pumpWidget(
        TestableWidgetWithMediaQuery(
          width: 800,
          height: 600,
          child: IncidentForm(state),
        ),
      );

      return find.byType(TdButton);
    }

    testWidgets('find one button when not submitting',
        (WidgetTester tester) async {
      expect(
        await buttonFinder(
          tester,
          IncidentState(currentOperator: currentOperator),
        ),
        findsOneWidget,
      );
    });

    testWidgets('find no button when submitting', (WidgetTester tester) async {
      expect(
        await buttonFinder(
          tester,
          IncidentSubmitted(currentOperator: currentOperator),
        ),
        findsNothing,
      );
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
