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
      final branchA = TestConstants.branch;
      final branchB = TdBranch(id: 'b', name: 'b');
      final branchC = TdBranch(id: 'c', name: 'c');

      await tester.pumpWidget(TestableWidgetWithMediaQuery(
        child: SearchList<TdBranch>(
          name: 'name',
          validationText: 'validation',
          items: [branchA, branchB, branchC],
        ),
      ));

      expect(find.text('name'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('with items - nothing selected - show validation text',
        (WidgetTester tester) async {
      final branchA = TestConstants.branch;
      final branchB = TdBranch(id: 'b', name: 'b');
      final branchC = TdBranch(id: 'c', name: 'c');

      final formKey = GlobalKey<FormState>();
      await tester.pumpWidget(TestableWidgetWithMediaQuery(
        child: Form(
          key: formKey,
          child: SearchList<TdBranch>(
            name: 'name',
            validationText: 'validation',
            items: [branchA, branchB, branchC],
          ),
        ),
      ));

      expect(formKey.currentState.validate(), isFalse);
      await tester.pump();
      expect(find.text('validation'), findsOneWidget);
    });
  });
}
