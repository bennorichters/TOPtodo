import 'package:test/test.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:toptodo/blocs/settings/bloc.dart';
import 'package:toptodo_data/toptodo_data.dart';
import 'package:toptodo_topdesk_provider_mock/toptodo_topdesk_provider_mock.dart';

import '../init/init_bloc_test.dart';

class MockSettingsProvider extends Mock implements SettingsProvider {}

void main() {
  group('SettingsInit', () {
    final settingsProvider = MockSettingsProvider();
    final topdeskProvider = FakeTopdeskProvider(latency: Duration.zero);
    var bloc,
        branchA,
        callerAa,
        callerAb,
        categoryA,
        subCategoryAa,
        subCategoryAb,
        durationA,
        operatorA,
        categories,
        subCategories,
        durations;

    setUp(() async {
      branchA = await topdeskProvider.tdBranch(id: 'a');
      callerAa = await topdeskProvider.tdCaller(id: 'aa');
      callerAb = await topdeskProvider.tdCaller(id: 'ab');
      categoryA = await topdeskProvider.tdCategory(id: 'a');
      subCategoryAa = await topdeskProvider.tdSubcategory(id: 'aa');
      subCategoryAb = await topdeskProvider.tdSubcategory(id: 'ab');
      durationA = await topdeskProvider.tdDuration(id: 'a');
      operatorA = await topdeskProvider.tdOperator(id: 'a');

      categories = await topdeskProvider.tdCategories();
      subCategories = await topdeskProvider.tdSubcategories(tdCategory: categoryA);
      durations = await topdeskProvider.tdDurations();

      bloc = SettingsBloc(
        settingsProvider: settingsProvider,
        topdeskProvider: topdeskProvider,
      );
    });

    test('correct settings', () async {
      when(settingsProvider.provide()).thenAnswer(
        (_) => Future<Settings>.value(
          Settings(
            tdBranchId: branchA.id,
            tdCallerId: callerAa.id,
            tdCategoryId: categoryA.id,
            tdSubcategoryId: subCategoryAa.id,
            tdDurationId: durationA.id,
            tdOperatorId: operatorA.id,
          ),
        ),
      );

      bloc.add(const SettingsInit());

      await emitsExactly<SettingsBloc, SettingsState>(
        bloc,
        [
          const InitialSettingsState(),
          SettingsLoading(
            currentOperator: await topdeskProvider.currentTdOperator(),
          ),
          SettingsTdData(
            currentOperator: await topdeskProvider.currentTdOperator(),
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
            currentOperator: await topdeskProvider.currentTdOperator(),
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

    test('caller belongs to different branch', () async {
      when(settingsProvider.provide()).thenAnswer(
        (_) => Future<Settings>.value(
          Settings(
            tdBranchId: branchA.id,
            tdCallerId: callerAb.id,
            tdCategoryId: categoryA.id,
            tdSubcategoryId: subCategoryAa.id,
            tdDurationId: durationA.id,
            tdOperatorId: operatorA.id,
          ),
        ),
      );

      bloc.add(const SettingsInit());

      await emitsExactly<SettingsBloc, SettingsState>(
        bloc,
        [
          const InitialSettingsState(),
          SettingsLoading(
            currentOperator: await topdeskProvider.currentTdOperator(),
          ),
          SettingsTdData(
            currentOperator: await topdeskProvider.currentTdOperator(),
            formState: SettingsFormState(
              branch: branchA,
              caller: null,
              category: categoryA,
              subCategory: subCategoryAa,
              incidentDuration: durationA,
              incidentOperator: operatorA,
            ),
          ),
          SettingsTdData(
            currentOperator: await topdeskProvider.currentTdOperator(),
            formState: SettingsFormState(
              branch: branchA,
              caller: null,
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
            tdBranchId: branchA.id,
            tdCallerId: callerAa.id,
            tdCategoryId: categoryA.id,
            tdSubcategoryId: subCategoryAb.id,
            tdDurationId: durationA.id,
            tdOperatorId: operatorA.id,
          ),
        ),
      );

      bloc.add(const SettingsInit());

      await emitsExactly<SettingsBloc, SettingsState>(
        bloc,
        [
          const InitialSettingsState(),
          SettingsLoading(
            currentOperator: await topdeskProvider.currentTdOperator(),
          ),
          SettingsTdData(
            currentOperator: await topdeskProvider.currentTdOperator(),
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
            currentOperator: await topdeskProvider.currentTdOperator(),
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

    test('empty settings fill operator', () async {
      when(settingsProvider.provide())
          .thenAnswer((_) => Future<Settings>.value(Settings()));

      bloc.add(const SettingsInit());

      final currentOperator = await topdeskProvider.currentTdOperator();
      await emitsExactly<SettingsBloc, SettingsState>(
        bloc,
        [
          const InitialSettingsState(),
          SettingsLoading(currentOperator: currentOperator),
          SettingsTdData(
            currentOperator: currentOperator,
            formState: SettingsFormState(
              incidentOperator: currentOperator,
            ),
          ),
          SettingsTdData(
            currentOperator: currentOperator,
            formState: SettingsFormState(
              categories: categories,
              incidentDurations: durations,
              incidentOperator: currentOperator,
            ),
          ),
        ],
      );
    });

    test('empty settings dont fill operator', () async {
      when(settingsProvider.provide())
          .thenAnswer((_) => Future<Settings>.value(Settings()));

      final currentOperator = TdOperator(
        id: 'x',
        name: '',
        avatar: '',
        firstLine: false,
        secondLine: true,
      );
      final tdProviderWrongOperator = MockTopdeskProvider();
      when(tdProviderWrongOperator.currentTdOperator())
          .thenAnswer((_) => Future<TdOperator>.value(currentOperator));
      when(tdProviderWrongOperator.tdCategories())
          .thenAnswer((_) => topdeskProvider.tdCategories());
      when(tdProviderWrongOperator.tdDurations())
          .thenAnswer((_) => topdeskProvider.tdDurations());

      bloc = SettingsBloc(
        settingsProvider: settingsProvider,
        topdeskProvider: tdProviderWrongOperator,
      );
      bloc.add(const SettingsInit());

      await emitsExactly<SettingsBloc, SettingsState>(
        bloc,
        [
          const InitialSettingsState(),
          SettingsLoading(currentOperator: currentOperator),
          SettingsTdData(
            currentOperator: currentOperator,
            formState: SettingsFormState(),
          ),
          SettingsTdData(
            currentOperator: currentOperator,
            formState: SettingsFormState(
              categories: categories,
              incidentDurations: durations,
            ),
          ),
        ],
      );
    });
  });
}
