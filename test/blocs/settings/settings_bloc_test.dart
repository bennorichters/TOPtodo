import 'package:test/test.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:toptodo/blocs/settings/bloc.dart';
import 'package:toptodo_data/toptodo_data.dart';
import 'package:toptodo_topdesk_provider_mock/toptodo_topdesk_provider_mock.dart';

class MockSettingsProvider extends Mock implements SettingsProvider {}

void main() {
  group('SettingsInit', () {
    test('correct settings', () async {
      final tdp = FakeTopdeskProvider(latency: Duration.zero);
      final branchA = await tdp.branch(id: 'a');
      final callerA = await tdp.caller(id: 'aa');
      final categoryA = await tdp.category(id: 'a');
      final subCategoryA = await tdp.subCategory(id: 'aa');
      final durationA = await tdp.incidentDuration(id: 'a');
      final operatorA = await tdp.incidentOperator(id: 'a');

      final categories = await tdp.categories();
      final subCategories = await tdp.subCategories(category: categoryA);
      final durations = await tdp.incidentDurations();

      final settings = Settings(
        branchId: branchA.id,
        callerId: callerA.id,
        categoryId: categoryA.id,
        subCategoryId: subCategoryA.id,
        incidentDurationId: durationA.id,
        incidentOperatorId: operatorA.id,
      );
      final settingsProvider = MockSettingsProvider();
      when(settingsProvider.provide()).thenAnswer(
        (_) => Future<Settings>.value(settings),
      );

      final bloc = SettingsBloc(
        settingsProvider: settingsProvider,
        topdeskProvider: tdp,
      );

      bloc.add(const SettingsInit());

      await emitsExactly<SettingsBloc, SettingsState>(
        bloc,
        [
          const SettingsLoading(),
          SettingsTdData(
            formState: SettingsFormState(
              branch: branchA,
              caller: callerA,
              category: categoryA,
              subCategory: subCategoryA,
              incidentDuration: durationA,
              incidentOperator: operatorA,
            ),
          ),
          SettingsTdData(
            formState: SettingsFormState(
              branch: branchA,
              caller: callerA,
              category: categoryA,
              subCategory: subCategoryA,
              incidentDuration: durationA,
              incidentOperator: operatorA,
              categories: categories,
              subCategories: subCategories,
              incidentDurations: durations,
            ),
          ),
        ],
      );
    });
  });
}
