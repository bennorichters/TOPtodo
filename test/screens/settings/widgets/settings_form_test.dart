import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:toptodo/blocs/settings/bloc.dart';
import 'package:toptodo/blocs/td_model_search/bloc.dart';
import 'package:toptodo/constants/keys.dart' as ttd_keys;
import 'package:toptodo/screens/settings/widgets/settings_form.dart';

import '../../../test_helper.dart';
import '../../../test_constants.dart' as test_constants;

class MockSettingsBloc extends MockBloc<SettingsEvent, SettingsState>
    implements SettingsBloc {}

class MockTdModelSearchBloc
    extends MockBloc<TdModelSearchEvent, TdModelSearchState>
    implements TdModelSearchBloc {}

void main() {
  group('SettingsForm', () {
    testWidgets('basics', (WidgetTester tester) async {
      await tester.pumpWidget(TestableWidgetWithMediaQuery(
        child: SettingsForm(UpdatedSettingsForm(
          currentOperator: test_constants.currentOperator,
          formState: SettingsFormState(),
        )),
      ));

      expect(find.text('Caller (first choose a branch)'), findsOneWidget);
    });

    group('tap', () {
      SettingsBloc settingsBloc;
      TdModelSearchBloc searchBloc;

      setUp(() {
        settingsBloc = MockSettingsBloc();
        searchBloc = MockTdModelSearchBloc();
      });

      void pumpForm(WidgetTester tester, SettingsFormState state) async {
        await tester.pumpWidget(MultiBlocProvider(
          providers: [
            BlocProvider.value(value: searchBloc),
            BlocProvider.value(value: settingsBloc),
          ],
          child: TestableWidgetWithMediaQuery(
            child: SettingsForm(UpdatedSettingsForm(
              currentOperator: test_constants.currentOperator,
              formState: state,
            )),
          ),
        ));
      }

      void tapSearchField(
        WidgetTester tester,
        String key, [
        SettingsFormState state = const SettingsFormState(),
      ]) async {
        await pumpForm(tester, state);
        await tester.tap(find.descendant(
          of: find.byKey(Key(key)),
          matching: find.byType(Row),
        ));
        verify(searchBloc.add(NewSearch())).called(1);
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.arrow_back));
        verify(settingsBloc.add(ValueSelected())).called(1);
      }

      void tapSearchList(
        WidgetTester tester,
        String key,
        SettingsFormState state,
      ) async {
        await pumpForm(tester, state);
        await tester.tap(find.byKey(Key(key)));
      }

      testWidgets(
          'branch',
          (WidgetTester tester) async =>
              tapSearchField(tester, ttd_keys.settingsFormSearchFieldBranch));

      testWidgets(
        'caller',
        (WidgetTester tester) async => tapSearchField(
          tester,
          ttd_keys.settingsFormSearchFieldCaller,
          SettingsFormState(tdBranch: test_constants.branchA),
        ),
      );

      testWidgets(
          'operator',
          (WidgetTester tester) async =>
              tapSearchField(tester, ttd_keys.settingsFormSearchFieldOperator));

      testWidgets('category', (WidgetTester tester) async {
        tapSearchList(
          tester,
          ttd_keys.settingsFormSearchFieldCategory,
          SettingsFormState(
            tdCategories: [
              test_constants.categoryA,
              test_constants.categoryB,
              test_constants.categoryC,
            ],
          ),
        );
      });
    });
  });
}
