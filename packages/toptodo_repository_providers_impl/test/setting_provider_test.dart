import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toptodo_data/toptodo_data.dart';

import 'package:toptodo_repository_providers_impl/toptodo_repository_providers_impl.dart';

class MockTopdeskProvider extends Mock implements TopdeskProvider {}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, dynamic>{});
  });

  group('basics', () {
    const Branch branchA = Branch(
      id: 'a',
      name: 'BranchA',
    );
    const Branch branchB = Branch(
      id: 'b',
      name: 'BranchB',
    );
    const Caller callerA = Caller(
      id: 'a',
      name: 'CallerA',
      avatar: '',
      branch: branchA,
    );
    const Caller callerB = Caller(
      id: 'b',
      name: 'CallerB',
      avatar: '',
      branch: branchB,
    );
    const Category catA = Category(
      id: 'a',
      name: 'catA',
    );
    const Category catB = Category(
      id: 'b',
      name: 'catB',
    );
    const SubCategory subCatA = SubCategory(
      id: 'a',
      name: 'subCatA',
      category: catA,
    );
    const SubCategory subCatB = SubCategory(
      id: 'b',
      name: 'subCatB',
      category: catB,
    );
    const IncidentDuration durationA = IncidentDuration(
      id: 'a',
      name: 'durationA',
    );
    const IncidentOperator operatorA = IncidentOperator(
      id: 'a',
      name: 'opA',
      avatar: '',
    );
    const Settings settingsToSave = Settings(
      branch: branchA,
      caller: callerA,
      category: catA,
      subCategory: subCatA,
      incidentDuration: durationA,
      incidentOperator: operatorA,
    );

    final MockTopdeskProvider mtp = MockTopdeskProvider();
    when(mtp.branch(id: 'a')).thenAnswer(
      (_) => Future<Branch>.value(branchA),
    );
    when(mtp.caller(id: 'a')).thenAnswer(
      (_) => Future<Caller>.value(callerA),
    );
    when(mtp.caller(id: 'b')).thenAnswer(
      (_) => Future<Caller>.value(callerB),
    );
    when(mtp.category(id: 'a')).thenAnswer(
      (_) => Future<Category>.value(catA),
    );
    when(mtp.subCategory(id: 'a')).thenAnswer(
      (_) => Future<SubCategory>.value(subCatA),
    );
    when(mtp.subCategory(id: 'b')).thenAnswer(
      (_) => Future<SubCategory>.value(subCatB),
    );
    when(mtp.incidentDuration(id: 'a')).thenAnswer(
      (_) => Future<IncidentDuration>.value(durationA),
    );
    when(mtp.incidentOperator(id: 'a')).thenAnswer(
      (_) => Future<IncidentOperator>.value(operatorA),
    );

    test('first nothing then retrieve same as saved', () async {
      final SharedPreferencesSettingsProvider p =
          SharedPreferencesSettingsProvider(mtp);
      p.init('url', 'loginName');

      expect(await p.provide(), null);

      await p.save(settingsToSave);

      final Settings provided = await p.provide();
      expect(provided, settingsToSave);
    });

    test('retrieve twice', () async {
      final SharedPreferencesSettingsProvider p =
          SharedPreferencesSettingsProvider(mtp);
      p.init('url', 'loginName');

      expect(await p.provide(), null);

      await p.save(settingsToSave);

      final Settings provided = await p.provide();
      expect(provided, settingsToSave);

      final Settings provided2 = await p.provide();
      expect(provided2, settingsToSave);
    });

    test('different url does not contain the same settings', () async {
      final SharedPreferencesSettingsProvider p1 =
          SharedPreferencesSettingsProvider(mtp);
      p1.init('url1', 'loginName');

      await p1.save(settingsToSave);

      final SharedPreferencesSettingsProvider p2 =
          SharedPreferencesSettingsProvider(mtp);
      p2.init('url2', 'loginName');

      expect(await p2.provide(), null);
    });

    test('deleted duration', () async {
      const IncidentDuration durationB = IncidentDuration(
        id: 'b',
        name: 'durationB',
      );
      when(mtp.incidentDuration(id: 'b'))
          .thenThrow(const TdModelNotFoundException(''));

      final SharedPreferencesSettingsProvider p =
          SharedPreferencesSettingsProvider(mtp);
      p.init('url1', 'loginName');

      const Settings settingsWithDurationB = Settings(
        branch: branchA,
        caller: callerA,
        category: catA,
        subCategory: subCatA,
        incidentDuration: durationB,
        incidentOperator: operatorA,
      );
      await p.save(settingsWithDurationB);

      const Settings settingsWithoutDurationB = Settings(
        branch: branchA,
        caller: callerA,
        category: catA,
        subCategory: subCatA,
        incidentDuration: null,
        incidentOperator: operatorA,
      );
      final Settings provided = await p.provide();
      expect(provided, settingsWithoutDurationB);
    });

    test('caller belongs to different branch', () async {
      final SharedPreferencesSettingsProvider p =
          SharedPreferencesSettingsProvider(mtp);
      p.init('url1', 'loginName');

      const Settings settingsWithCallerB = Settings(
        branch: branchA,
        caller: callerB,
        category: catA,
        subCategory: subCatA,
        incidentDuration: durationA,
        incidentOperator: operatorA,
      );
      await p.save(settingsWithCallerB);

      const Settings settingsWithoutCallerB = Settings(
        branch: branchA,
        caller: null,
        category: catA,
        subCategory: subCatA,
        incidentDuration: durationA,
        incidentOperator: operatorA,
      );
      final Settings provided = await p.provide();
      expect(provided, settingsWithoutCallerB);
    });

    test('subcategory belongs to different category', () async {
      final SharedPreferencesSettingsProvider p =
          SharedPreferencesSettingsProvider(mtp);
      p.init('url1', 'loginName');

      const Settings settingsWithSubCatB = Settings(
        branch: branchA,
        caller: callerA,
        category: catA,
        subCategory: subCatB,
        incidentDuration: durationA,
        incidentOperator: operatorA,
      );
      await p.save(settingsWithSubCatB);

      const Settings settingsWithoutSubCatB = Settings(
        branch: branchA,
        caller: callerA,
        category: catA,
        subCategory: null,
        incidentDuration: durationA,
        incidentOperator: operatorA,
      );
      final Settings provided = await p.provide();
      expect(provided, settingsWithoutSubCatB);
    });
  });
}
