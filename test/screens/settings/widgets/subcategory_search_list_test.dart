import 'package:bloc_test/bloc_test.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:toptodo/blocs/settings/bloc.dart';
import 'package:toptodo/screens/settings/widgets/search_list.dart';
import 'package:toptodo/screens/settings/widgets/subcategory_search_list.dart';
import 'package:toptodo/constants/keys.dart' as ttd_keys;
import 'package:toptodo_data/toptodo_data.dart';

import '../../../test_helper.dart';

class MockSettingsBloc extends MockBloc<SettingsEvent, SettingsState>
    implements SettingsBloc {}

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
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byWidgetPredicate((w) => w is SearchList), findsNothing);
    });

    testWidgets('with category', (WidgetTester tester) async {
      final catA = TdCategory(id: 'a', name: 'a');
      final subAa = TdSubcategory(id: 'aa', name: 'aa', category: catA);
      final subAb = TdSubcategory(id: 'ab', name: 'ab', category: catA);

      await tester.pumpWidget(TestableWidgetWithMediaQuery(
        child: SubcategorySearchList(
          formState: SettingsFormState(
            tdCategory: catA,
            tdSubcategories: [subAa, subAb],
            tdSubcategory: subAa,
          ),
        ),
      ));

      expect(
        find.text('Subcategory (first choose a category)'),
        findsNothing,
      );
      expect(find.byType(TextFormField), findsNothing);
      expect(find.byWidgetPredicate((w) => w is SearchList), findsOneWidget);
    });

    testWidgets('searchListItemPrefix', (WidgetTester tester) async {
      SettingsBloc bloc = MockSettingsBloc();

      final catA = TdCategory(id: 'a', name: 'a');
      final subAa = TdSubcategory(id: 'aa', name: 'aa', category: catA);
      final subAb = TdSubcategory(id: 'ab', name: 'ab', category: catA);

      await tester.pumpWidget(TestableWidgetWithMediaQuery(
        child: BlocProvider.value(
          value: bloc,
          child: SubcategorySearchList(
            formState: SettingsFormState(
              tdCategory: catA,
              tdSubcategories: [subAa, subAb],
              tdSubcategory: subAa,
            ),
          ),
        ),
      ));

      final dropDown = find.byWidgetPredicate((w) => w is DropdownButton);
      await tester.tap(dropDown);
      await tester.pump();

      final item =
          find.byKey(Key(ttd_keys.subcategorySearchList + '_ab')).hitTestable();

      expect(item, findsOneWidget);

      await tester.tap(item);

      verify(bloc.add(ValueSelected(tdSubcategory: subAb))).called(1);
    });
  });
}
