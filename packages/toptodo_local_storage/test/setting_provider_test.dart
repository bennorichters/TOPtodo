import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toptodo_data/toptodo_data.dart';

import 'package:toptodo_local_storage/toptodo_local_storage.dart';

class MockTopdeskProvider extends Mock implements TopdeskProvider {}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, dynamic>{});
  });

  group('basics', () {
    final settingsToSave = Settings(
      tdBranchId: 'a',
      tdCallerId: 'a',
      tdCategoryId: 'a',
      tdSubcategoryId: 'a',
      tdDurationId: 'a',
      tdOperatorId: 'a',
    );

    test('first empty settings then retrieve same as saved', () async {
      final p = SharedPreferencesSettingsProvider();
      p.init('url', 'loginName');

      expect(await p.provide(), const Settings());

      await p.save(settingsToSave);

      final Settings provided = await p.provide();
      expect(provided, settingsToSave);
    });

    test('retrieve same as saved after dispose', () async {
      final p = SharedPreferencesSettingsProvider();
      p.init('url', 'loginName');
      await p.save(settingsToSave);
      p.dispose();

      p.init('url', 'loginName');
      final Settings provided = await p.provide();
      expect(provided, settingsToSave);
    });

    test('retrieve empty after save and delete', () async {
      final p = SharedPreferencesSettingsProvider();
      p.init('url', 'loginName');
      await p.save(settingsToSave);
      p.dispose();
      await p.delete();

      p.init('url', 'loginName');
      expect(await p.provide(), Settings());
    });

    test('retrieve twice', () async {
      final p = SharedPreferencesSettingsProvider();
      p.init('url', 'loginName');

      expect(await p.provide(), const Settings());

      await p.save(settingsToSave);

      final provided = await p.provide();
      expect(provided, settingsToSave);

      final provided2 = await p.provide();
      expect(provided2, settingsToSave);
    });

    test('different url does not contain the same settings', () async {
      final p1 = SharedPreferencesSettingsProvider();
      p1.init('url1', 'loginName');

      await p1.save(settingsToSave);

      final p2 = SharedPreferencesSettingsProvider();
      p2.init('url2', 'loginName');

      expect(await p2.provide(), const Settings());
    });
  });
}
