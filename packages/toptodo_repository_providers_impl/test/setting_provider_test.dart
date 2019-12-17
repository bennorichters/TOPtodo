import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toptodo_data/toptodo_data.dart';

import 'package:toptodo_repository_providers_impl/toptodo_repository_providers_impl.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, dynamic>{});
  });

  test('first nothing then retrieve same as saved', () async {
    final SharedPreferencesSettingsProvider p =
        SharedPreferencesSettingsProvider();
    p.init('url', 'loginName');

    expect(await p.provide(), null);

    const Settings s = Settings(
      branchId: 'b',
      callerId: 'c',
      categoryId: 'cat',
      subcategoryId: 'sub',
      incidentDurationId: 'd',
      incidentOperatorId: 'o',
    );

    await p.save(s);

    final Settings provided = await p.provide();
    expect(provided.branchId, 'b');
    expect(provided.callerId, 'c');
    expect(provided.categoryId, 'cat');
    expect(provided.subcategoryId, 'sub');
    expect(provided.incidentDurationId, 'd');
    expect(provided.incidentOperatorId, 'o');
  });

  test('different url does not contain the same settings', () async {
    final SharedPreferencesSettingsProvider p1 =
        SharedPreferencesSettingsProvider();
    p1.init('url1', 'loginName');

    const Settings s = Settings(
      branchId: 'b',
      callerId: 'c',
      categoryId: 'cat',
      subcategoryId: 'sub',
      incidentDurationId: 'd',
      incidentOperatorId: 'o',
    );

    await p1.save(s);

    final SharedPreferencesSettingsProvider p2 =
        SharedPreferencesSettingsProvider();
    p2.init('url2', 'loginName');

    expect(await p2.provide(), null);
  });
}
