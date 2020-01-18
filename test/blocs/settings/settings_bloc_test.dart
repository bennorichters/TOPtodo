import 'package:test/test.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:toptodo/blocs/settings/bloc.dart';
import 'package:toptodo_data/toptodo_data.dart';
import 'package:toptodo_topdesk_provider_mock/toptodo_topdesk_provider_mock.dart';

import '../init/init_bloc_test.dart';

class MockSettingsProvider extends Mock implements SettingsProvider {}

void main() {
  group('settings bloc', () {
    group('SettingsInit', () {
      final settingsProvider = MockSettingsProvider();
      final topdeskProvider = FakeTopdeskProvider(latency: Duration.zero);
      var bloc,
          branchA,
          callerAa,
          callerAb,
          categoryA,
          subcategoryAa,
          subcategoryAb,
          durationA,
          operatorA,
          categories,
          subcategories,
          durations;

      setUp(() async {
        branchA = await topdeskProvider.tdBranch(id: 'a');
        callerAa = await topdeskProvider.tdCaller(id: 'aa');
        callerAb = await topdeskProvider.tdCaller(id: 'ab');
        categoryA = await topdeskProvider.tdCategory(id: 'a');
        subcategoryAa = await topdeskProvider.tdSubcategory(id: 'aa');
        subcategoryAb = await topdeskProvider.tdSubcategory(id: 'ab');
        durationA = await topdeskProvider.tdDuration(id: 'a');
        operatorA = await topdeskProvider.tdOperator(id: 'a');

        categories = await topdeskProvider.tdCategories();
        subcategories =
            await topdeskProvider.tdSubcategories(tdCategory: categoryA);
        durations = await topdeskProvider.tdDurations();

        bloc = SettingsBloc(
          settingsProvider: settingsProvider,
          topdeskProvider: topdeskProvider,
        );
      });

      test('correct settings', () async {
        when(settingsProvider.provide()).thenAnswer(
          (_) => Future.value(
            Settings(
              tdBranchId: branchA.id,
              tdCallerId: callerAa.id,
              tdCategoryId: categoryA.id,
              tdSubcategoryId: subcategoryAa.id,
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
                tdBranch: branchA,
                tdCaller: callerAa,
                tdCategory: categoryA,
                tdSubcategory: subcategoryAa,
                tdDuration: durationA,
                tdOperator: operatorA,
              ),
            ),
            SettingsTdData(
              currentOperator: await topdeskProvider.currentTdOperator(),
              formState: SettingsFormState(
                tdBranch: branchA,
                tdCaller: callerAa,
                tdCategory: categoryA,
                tdSubcategory: subcategoryAa,
                tdDuration: durationA,
                tdOperator: operatorA,
                tdCategories: categories,
                tdSubcategories: subcategories,
                tdDurations: durations,
              ),
            ),
          ],
        );
      });

      test('caller belongs to different branch', () async {
        when(settingsProvider.provide()).thenAnswer(
          (_) => Future.value(
            Settings(
              tdBranchId: branchA.id,
              tdCallerId: callerAb.id,
              tdCategoryId: categoryA.id,
              tdSubcategoryId: subcategoryAa.id,
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
                tdBranch: branchA,
                tdCaller: null,
                tdCategory: categoryA,
                tdSubcategory: subcategoryAa,
                tdDuration: durationA,
                tdOperator: operatorA,
              ),
            ),
            SettingsTdData(
              currentOperator: await topdeskProvider.currentTdOperator(),
              formState: SettingsFormState(
                tdBranch: branchA,
                tdCaller: null,
                tdCategory: categoryA,
                tdSubcategory: subcategoryAa,
                tdDuration: durationA,
                tdOperator: operatorA,
                tdCategories: categories,
                tdSubcategories: subcategories,
                tdDurations: durations,
              ),
            ),
          ],
        );
      });

      test('sub category belongs to different category', () async {
        when(settingsProvider.provide()).thenAnswer(
          (_) => Future.value(
            Settings(
              tdBranchId: branchA.id,
              tdCallerId: callerAa.id,
              tdCategoryId: categoryA.id,
              tdSubcategoryId: subcategoryAb.id,
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
                tdBranch: branchA,
                tdCaller: callerAa,
                tdCategory: categoryA,
                tdSubcategory: null,
                tdDuration: durationA,
                tdOperator: operatorA,
              ),
            ),
            SettingsTdData(
              currentOperator: await topdeskProvider.currentTdOperator(),
              formState: SettingsFormState(
                tdBranch: branchA,
                tdCaller: callerAa,
                tdCategory: categoryA,
                tdSubcategory: null,
                tdDuration: durationA,
                tdOperator: operatorA,
                tdCategories: categories,
                tdSubcategories: subcategories,
                tdDurations: durations,
              ),
            ),
          ],
        );
      });

      test('empty settings fill operator', () async {
        when(settingsProvider.provide())
            .thenAnswer((_) => Future.value(Settings()));

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
                tdOperator: currentOperator,
              ),
            ),
            SettingsTdData(
              currentOperator: currentOperator,
              formState: SettingsFormState(
                tdCategories: categories,
                tdDurations: durations,
                tdOperator: currentOperator,
              ),
            ),
          ],
        );
      });

      test('empty settings dont fill operator', () async {
        when(settingsProvider.provide())
            .thenAnswer((_) => Future.value(Settings()));

        final currentOperator = TdOperator(
          id: 'x',
          name: '',
          avatar: '',
          firstLine: false,
          secondLine: true,
        );
        final tdProviderWrongOperator = MockTopdeskProvider();
        when(tdProviderWrongOperator.currentTdOperator())
            .thenAnswer((_) => Future.value(currentOperator));
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
                tdCategories: categories,
                tdDurations: durations,
              ),
            ),
          ],
        );
      });
    });

    group('item selected', () {
      final currentOperator = TdOperator(
        id: 'dawn',
        name: 'Dawn Meadows',
        avatar: 'image',
        firstLine: true,
        secondLine: true,
      );

      final branchA = TdBranch(id: '1', name: 'branch A');
      final callerA = TdCaller(
        id: '1',
        name: 'caller A',
        avatar: 'img',
        branch: branchA,
      );
      final categoryA = TdCategory(id: '1', name: 'category A');
      final subcategoryA = TdSubcategory(
        id: '11',
        name: 'subcategory A',
        category: categoryA,
      );
      final durationA = TdDuration(id: '1', name: 'duration A');
      final operatorA = TdOperator(
        id: '1',
        name: 'operator A',
        avatar: 'img',
        firstLine: true,
        secondLine: true,
      );

      final topdeskProvider = MockTopdeskProvider();
      when(topdeskProvider.currentTdOperator())
          .thenAnswer((_) => Future.value(currentOperator));

      final settingsProvider = MockSettingsProvider();
      when(settingsProvider.provide())
          .thenAnswer((_) => Future.value(Settings()));

      blocTest<SettingsBloc, SettingsEvent, SettingsState>(
        'first branch then caller',
        build: () => SettingsBloc(
          settingsProvider: settingsProvider,
          topdeskProvider: topdeskProvider,
        ),
        act: (SettingsBloc bloc) async {
          await bloc.add(SettingsInit());
          await bloc.add(SettingsBranchSelected(branchA));
          await bloc.add(SettingsCallerSelected(callerA));
        },
        expect: [
          InitialSettingsState(),
          SettingsLoading(currentOperator: currentOperator),
          SettingsTdData(
            currentOperator: currentOperator,
            formState: SettingsFormState(
              tdOperator: currentOperator,
            ),
          ),
          SettingsTdData(
            currentOperator: currentOperator,
            formState: SettingsFormState(
              tdBranch: branchA,
              tdOperator: currentOperator,
            ),
          ),
          SettingsTdData(
            currentOperator: currentOperator,
            formState: SettingsFormState(
              tdBranch: branchA,
              tdCaller: callerA,
              tdOperator: currentOperator,
            ),
          ),
        ],
      );

      blocTest<SettingsBloc, SettingsEvent, SettingsState>(
        'first category then subcategory',
        build: () => SettingsBloc(
          settingsProvider: settingsProvider,
          topdeskProvider: topdeskProvider,
        ),
        act: (SettingsBloc bloc) async {
          await bloc.add(SettingsInit());
          await bloc.add(SettingsCategorySelected(categoryA));
          await bloc.add(SettingsSubcategorySelected(subcategoryA));
        },
        expect: [
          InitialSettingsState(),
          SettingsLoading(currentOperator: currentOperator),
          SettingsTdData(
            currentOperator: currentOperator,
            formState: SettingsFormState(
              tdOperator: currentOperator,
            ),
          ),
          SettingsTdData(
            currentOperator: currentOperator,
            formState: SettingsFormState(
              tdCategory: categoryA,
              tdOperator: currentOperator,
            ),
          ),
          SettingsTdData(
            currentOperator: currentOperator,
            formState: SettingsFormState(
              tdCategory: categoryA,
              tdSubcategory: subcategoryA,
              tdOperator: currentOperator,
            ),
          ),
        ],
      );

      blocTest<SettingsBloc, SettingsEvent, SettingsState>(
        'duration',
        build: () => SettingsBloc(
          settingsProvider: settingsProvider,
          topdeskProvider: topdeskProvider,
        ),
        act: (SettingsBloc bloc) async {
          await bloc.add(SettingsInit());
          await bloc.add(SettingsDurationSelected(durationA));
        },
        expect: [
          InitialSettingsState(),
          SettingsLoading(currentOperator: currentOperator),
          SettingsTdData(
            currentOperator: currentOperator,
            formState: SettingsFormState(
              tdOperator: currentOperator,
            ),
          ),
          SettingsTdData(
            currentOperator: currentOperator,
            formState: SettingsFormState(
              tdDuration: durationA,
              tdOperator: currentOperator,
            ),
          ),
        ],
      );

      blocTest<SettingsBloc, SettingsEvent, SettingsState>(
        'operator',
        build: () => SettingsBloc(
          settingsProvider: settingsProvider,
          topdeskProvider: topdeskProvider,
        ),
        act: (SettingsBloc bloc) async {
          await bloc.add(SettingsInit());
          await bloc.add(SettingsOperatorSelected(operatorA));
        },
        expect: [
          InitialSettingsState(),
          SettingsLoading(currentOperator: currentOperator),
          SettingsTdData(
            currentOperator: currentOperator,
            formState: SettingsFormState(
              tdOperator: currentOperator,
            ),
          ),
          SettingsTdData(
            currentOperator: currentOperator,
            formState: SettingsFormState(
              tdOperator: operatorA,
            ),
          ),
        ],
      );
    });
  });
}
