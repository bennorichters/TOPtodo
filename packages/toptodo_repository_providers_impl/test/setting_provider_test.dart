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
    const Caller callerA = Caller(
      id: 'a',
      name: 'CallerA',
      avatar: '',
      branch: branchA,
    );
    const Category catA = Category(
      id: 'a',
      name: 'catA',
    );
    const SubCategory subCatA = SubCategory(
      id: 'a',
      name: 'subCatA',
      category: catA,
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
    when(mtp.category(id: 'a')).thenAnswer(
      (_) => Future<Category>.value(catA),
    );
    when(mtp.subCategory(id: 'a')).thenAnswer(
      (_) => Future<SubCategory>.value(subCatA),
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
  });
}
