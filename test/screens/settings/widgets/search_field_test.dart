import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:toptodo/screens/settings/widgets/search_field.dart';

import 'package:toptodo_data/toptodo_data.dart';

import '../../../test_helper.dart';
import '../../../test_constants.dart' as test_constants;

void main() {
  group('SearchField', () {
    testWidgets('find label', (WidgetTester tester) async {
      await tester.pumpWidget(TestableWidgetWithMediaQuery(
        child: SearchField<TdBranch>(
          value: null,
          label: 'label',
          validationText: 'validation',
          search: () {},
        ),
      ));

      expect(find.text('label'), findsOneWidget);
    });

    testWidgets('find value', (WidgetTester tester) async {
      await tester.pumpWidget(TestableWidgetWithMediaQuery(
        child: SearchField<TdBranch>(
          value: test_constants.branchA,
          label: 'label',
          validationText: 'validation',
          search: () {},
        ),
      ));

      expect(find.text('a'), findsOneWidget);
    });

    testWidgets('tap row triggers search', (WidgetTester tester) async {
      var hasSearched = false;
      await tester.pumpWidget(TestableWidgetWithMediaQuery(
        child: SearchField<TdBranch>(
          value: test_constants.branchA,
          label: 'label',
          validationText: 'validation',
          search: () => hasSearched = true,
        ),
      ));

      expect(hasSearched, isFalse);

      final findRow = find.byType(Row);
      await tester.tap(findRow);
      await tester.pump();

      expect(hasSearched, isTrue);
    });

    testWidgets('with value is validate', (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();
      await tester.pumpWidget(TestableWidgetWithMediaQuery(
        child: Form(
          key: formKey,
          child: SearchField<TdBranch>(
            value: test_constants.branchA,
            label: 'label',
            validationText: 'validation',
            search: () {},
          ),
        ),
      ));

      expect(formKey.currentState.validate(), isTrue);
      await tester.pump();
      expect(find.text('validation'), findsNothing);
    });

    testWidgets('without value is not validate', (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();
      await tester.pumpWidget(TestableWidgetWithMediaQuery(
        child: Form(
          key: formKey,
          child: SearchField<TdBranch>(
            value: null,
            label: 'label',
            validationText: 'validation',
            search: () {},
          ),
        ),
      ));

      expect(formKey.currentState.validate(), isFalse);
      await tester.pump();
      expect(find.text('validation'), findsOneWidget);
    });
  });
}
