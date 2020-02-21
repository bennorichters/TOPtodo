import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:toptodo/blocs/settings/bloc.dart';
import 'package:toptodo/blocs/td_model_search/bloc.dart';
import 'package:toptodo/constants/keys.dart' as ttd_keys;
import 'package:toptodo/screens/settings/widgets/settings_form.dart';
import 'package:toptodo_data/toptodo_data.dart';

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

    group('with blocs', () {
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

      group('tap', () {
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

        void tapSearchList({
          WidgetTester tester,
          String key,
          SettingsFormState state,
          TdModel itemToChoose,
          ValueSelected expectedEvent,
        }) async {
          await pumpForm(tester, state);

          await tester.tap(find.descendant(
            of: find.byKey(Key(key)),
            matching: find.byWidgetPredicate((w) => w is DropdownButton),
          ));
          await tester.pump();

          final item =
              find.byKey(Key(key + '_' + itemToChoose.id)).hitTestable();
          await tester.tap(item);
          verify(settingsBloc.add(expectedEvent)).called(1);
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
            (WidgetTester tester) async => tapSearchField(
                tester, ttd_keys.settingsFormSearchFieldOperator));

        testWidgets(
            'category',
            (WidgetTester tester) async => tapSearchList(
                  tester: tester,
                  key: ttd_keys.settingsFormSearchFieldCategory,
                  state: SettingsFormState(
                    tdCategories: [
                      test_constants.categoryA,
                      test_constants.categoryB,
                      test_constants.categoryC,
                    ],
                  ),
                  itemToChoose: test_constants.categoryB,
                  expectedEvent: ValueSelected(
                    tdCategory: test_constants.categoryB,
                  ),
                ));

        testWidgets(
            'duration',
            (WidgetTester tester) async => tapSearchList(
                  tester: tester,
                  key: ttd_keys.settingsFormSearchFieldDuration,
                  state: SettingsFormState(
                    tdDurations: [
                      test_constants.durationA,
                      test_constants.durationB,
                      test_constants.durationC,
                    ],
                  ),
                  itemToChoose: test_constants.durationB,
                  expectedEvent: ValueSelected(
                    tdDuration: test_constants.durationB,
                  ),
                ));
      });

      group('save', () {
        testWidgets('tap button', (WidgetTester tester) async {
          // TODO
        });
      });
    });
  });
}
