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
  });
}
