import 'package:test/test.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:toptodo/blocs/settings/bloc.dart';
import 'package:toptodo_data/toptodo_data.dart';
import 'package:toptodo_topdesk_provider_mock/toptodo_topdesk_provider_mock.dart';

class MockSettingsProvider extends Mock implements SettingsProvider {}

void main() {
  group('SettingsInit', () {
    final settingsProvider = MockSettingsProvider();
    var tdp,
        bloc,
        branchA,
        callerAa,
        categoryA,
        subCategoryAa,
        subCategoryAb,
        durationA,
        operatorA,
        categories,
        subCategories,
        durations;

    setUp(() async {
      tdp = FakeTopdeskProvider(latency: Duration.zero);

      branchA = await tdp.branch(id: 'a');
      callerAa = await tdp.caller(id: 'aa');
      categoryA = await tdp.category(id: 'a');
      subCategoryAa = await tdp.subCategory(id: 'aa');
      subCategoryAb = await tdp.subCategory(id: 'ab');
      durationA = await tdp.incidentDuration(id: 'a');
      operatorA = await tdp.incidentOperator(id: 'a');

      categories = await tdp.categories();
      subCategories = await tdp.subCategories(category: categoryA);
      durations = await tdp.incidentDurations();

      bloc = SettingsBloc(
        settingsProvider: settingsProvider,
        topdeskProvider: tdp,
      );
    });

    test('correct settings', () async {
      when(settingsProvider.provide()).thenAnswer(
        (_) => Future<Settings>.value(
          Settings(
            branchId: branchA.id,
            callerId: callerAa.id,
            categoryId: categoryA.id,
            subCategoryId: subCategoryAa.id,
            incidentDurationId: durationA.id,
            incidentOperatorId: operatorA.id,
          ),
        ),
      );

      bloc.add(const SettingsInit());

      await emitsExactly<SettingsBloc, SettingsState>(
        bloc,
        [
          const SettingsLoading(),
          SettingsTdData(
            formState: SettingsFormState(
              branch: branchA,
              caller: callerAa,
              category: categoryA,
              subCategory: subCategoryAa,
              incidentDuration: durationA,
              incidentOperator: operatorA,
            ),
          ),
          SettingsTdData(
            formState: SettingsFormState(
              branch: branchA,
              caller: callerAa,
              category: categoryA,
              subCategory: subCategoryAa,
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

    test('sub category belongs to different category', () async {
      when(settingsProvider.provide()).thenAnswer(
        (_) => Future<Settings>.value(
          Settings(
            branchId: branchA.id,
            callerId: callerAa.id,
            categoryId: categoryA.id,
            subCategoryId: subCategoryAb.id,
            incidentDurationId: durationA.id,
            incidentOperatorId: operatorA.id,
          ),
        ),
      );

      bloc.add(const SettingsInit());

      await emitsExactly<SettingsBloc, SettingsState>(
        bloc,
        [
          const SettingsLoading(),
          SettingsTdData(
            formState: SettingsFormState(
              branch: branchA,
              caller: callerAa,
              category: categoryA,
              subCategory: null,
              incidentDuration: durationA,
              incidentOperator: operatorA,
            ),
          ),
          SettingsTdData(
            formState: SettingsFormState(
              branch: branchA,
              caller: callerAa,
              category: categoryA,
              subCategory: null,
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
