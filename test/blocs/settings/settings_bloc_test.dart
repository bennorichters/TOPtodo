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
      branchA = await topdeskProvider.branch(id: 'a');
      callerAa = await topdeskProvider.caller(id: 'aa');
      callerAb = await topdeskProvider.caller(id: 'ab');
      categoryA = await topdeskProvider.category(id: 'a');
      subCategoryAa = await topdeskProvider.subCategory(id: 'aa');
      subCategoryAb = await topdeskProvider.subCategory(id: 'ab');
      durationA = await topdeskProvider.incidentDuration(id: 'a');
      operatorA = await topdeskProvider.incidentOperator(id: 'a');

      categories = await topdeskProvider.categories();
      subCategories = await topdeskProvider.subCategories(category: categoryA);
      durations = await topdeskProvider.incidentDurations();

      bloc = SettingsBloc(
        settingsProvider: settingsProvider,
        topdeskProvider: topdeskProvider,
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
          const InitialSettingsState(),
          SettingsLoading(
            currentOperator: await topdeskProvider.currentIncidentOperator(),
          ),
          SettingsTdData(
            currentOperator: await topdeskProvider.currentIncidentOperator(),
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
            currentOperator: await topdeskProvider.currentIncidentOperator(),
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
            branchId: branchA.id,
            callerId: callerAb.id,
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
          const InitialSettingsState(),
          SettingsLoading(
            currentOperator: await topdeskProvider.currentIncidentOperator(),
          ),
          SettingsTdData(
            currentOperator: await topdeskProvider.currentIncidentOperator(),
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
            currentOperator: await topdeskProvider.currentIncidentOperator(),
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
          const InitialSettingsState(),
          SettingsLoading(
            currentOperator: await topdeskProvider.currentIncidentOperator(),
          ),
          SettingsTdData(
            currentOperator: await topdeskProvider.currentIncidentOperator(),
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
            currentOperator: await topdeskProvider.currentIncidentOperator(),
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
          .thenAnswer((_) => Future<Settings>.value(Settings.empty()));

      bloc.add(const SettingsInit());

      final currentOperator = await topdeskProvider.currentIncidentOperator();
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
          .thenAnswer((_) => Future<Settings>.value(Settings.empty()));

      final currentOperator = IncidentOperator(
        id: 'x',
        name: '',
        avatar: '',
        firstLine: false,
        secondLine: true,
      );
      final tdProviderWrongOperator = MockTopdeskProvider();
      when(tdProviderWrongOperator.currentIncidentOperator())
          .thenAnswer((_) => Future<IncidentOperator>.value(currentOperator));
      when(tdProviderWrongOperator.categories())
          .thenAnswer((_) => topdeskProvider.categories());
      when(tdProviderWrongOperator.incidentDurations())
          .thenAnswer((_) => topdeskProvider.incidentDurations());

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
