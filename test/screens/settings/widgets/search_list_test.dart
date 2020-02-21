import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:toptodo_data/toptodo_data.dart';

import 'package:toptodo/screens/settings/widgets/search_list.dart';

import '../../../helper.dart';

void main() {
  group('SearchList', () {
    testWidgets('find label', (WidgetTester tester) async {
      await tester.pumpWidget(TestableWidgetWithMediaQuery(
        child: SearchList<TdBranch>(
          name: 'name',
          validationText: 'validation',
        ),
      ));

      expect(find.text('name'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('with items', (WidgetTester tester) async {
      await tester.pumpWidget(TestableWidgetWithMediaQuery(
        child: SearchList<TdBranch>(
          name: 'name',
          validationText: 'validation',
          items: [
            TestConstants.branchA,
            TestConstants.branchB,
            TestConstants.branchC,
          ],
        ),
      ));

      expect(find.text('name'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('with items - nothing selected - show validation text',
        (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();
      await tester.pumpWidget(TestableWidgetWithMediaQuery(
        child: Form(
          key: formKey,
          child: SearchList<TdBranch>(
            name: 'name',
            validationText: 'validation',
            items: [
              TestConstants.branchA,
              TestConstants.branchB,
              TestConstants.branchC,
            ],
          ),
        ),
      ));

      expect(formKey.currentState.validate(), isFalse);
      await tester.pump();
      expect(find.text('validation'), findsOneWidget);
    });
  });
}
