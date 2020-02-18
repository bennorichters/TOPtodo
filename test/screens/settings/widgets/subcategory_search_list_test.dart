import 'package:flutter_test/flutter_test.dart';
import 'package:toptodo/blocs/settings/bloc.dart';
import 'package:toptodo/screens/settings/widgets/subcategory_search_list.dart';

import '../../../helper.dart';

void main() {
  group('SubcategorySearchList', () {
    testWidgets('without category', (WidgetTester tester) async {
      await tester.pumpWidget(TestableWidgetWithMediaQuery(
        child: SubcategorySearchList(
          formState: SettingsFormState(),
        ),
      ));

      expect(
        find.text('Subcategory (first choose a category)'),
        findsOneWidget,
      );
    });
  });
}
