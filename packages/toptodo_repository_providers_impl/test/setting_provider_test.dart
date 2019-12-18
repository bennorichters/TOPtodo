import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toptodo_data/toptodo_data.dart';

import 'package:toptodo_repository_providers_impl/toptodo_repository_providers_impl.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, dynamic>{});
  });

  group('basics', () {
    const Branch branchA = Branch(id: 'a', name: 'BranchA');
    const Category catA = Category(id: 'a', name: 'catA');
    const Settings settingsToSave = Settings(
      branch: branchA,
      caller: Caller(id: 'a', name: 'CallerA', avatar: '', branch: branchA),
      category: catA,
      subCategory: SubCategory(id: 'a', name: 'subCatA', category: catA),
      incidentDuration: IncidentDuration(id: 'a', name: 'durationA'),
      incidentOperator: IncidentOperator(id: 'a', name: 'opA', avatar: ''),
    );

    test('first nothing then retrieve same as saved', () async {
      final SharedPreferencesSettingsProvider p =
          SharedPreferencesSettingsProvider();
      p.init('url', 'loginName');

      expect(await p.provide(), null);

      await p.save(settingsToSave);

      final Settings provided = await p.provide();
      expect(provided, settingsToSave);
    });

    test('different url does not contain the same settings', () async {
      final SharedPreferencesSettingsProvider p1 =
          SharedPreferencesSettingsProvider();
      p1.init('url1', 'loginName');

      await p1.save(settingsToSave);

      final SharedPreferencesSettingsProvider p2 =
          SharedPreferencesSettingsProvider();
      p2.init('url2', 'loginName');

      expect(await p2.provide(), null);
    });
  });
}
