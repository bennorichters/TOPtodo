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
    SettingsBloc settingsBloc;
    TdModelSearchBloc searchBloc;

    setUp(() {
      settingsBloc = MockSettingsBloc();
      searchBloc = MockTdModelSearchBloc();
    });

    testWidgets('basics', (WidgetTester tester) async {
      await tester.pumpWidget(TestableWidgetWithMediaQuery(
        child: SettingsForm(UpdatedSettingsForm(
          currentOperator: test_constants.currentOperator,
          formState: SettingsFormState(),
        )),
      ));

      expect(find.text('Caller (first choose a branch)'), findsOneWidget);
    });

    testWidgets('tapping branch', (WidgetTester tester) async {
      await tester.pumpWidget(MultiBlocProvider(
        providers: [
          BlocProvider.value(value: searchBloc),
          BlocProvider.value(value: settingsBloc),
        ],
        child: TestableWidgetWithMediaQuery(
          child: SettingsForm(UpdatedSettingsForm(
            currentOperator: test_constants.currentOperator,
            formState: SettingsFormState(),
          )),
        ),
      ));

      await tester.tap(find.descendant(
        of: find.byKey(Key(ttd_keys.settingsFormSearchFieldBranch)),
        matching: find.byType(Row),
      ));
      verify(searchBloc.add(NewSearch())).called(1);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_back));
      verify(settingsBloc.add(ValueSelected(tdBranch: null))).called(1);
    });
  });
}
