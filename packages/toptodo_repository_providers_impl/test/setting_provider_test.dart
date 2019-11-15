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
        SharedPreferencesSettingsProvider(
      'url',
      'loginName',
    );

    expect(await p.provide(), null);

    const Settings s = Settings(
      branchId: 'b',
      callerId: 'c',
      categoryId: 'cat',
      subcategoryId: 'sub',
      durationId: 'd',
      operatorId: 'o',
    );

    await p.save(s);

    final Settings provided = await p.provide();
    expect(provided.branchId, 'b');
    expect(provided.callerId, 'c');
    expect(provided.categoryId, 'cat');
    expect(provided.subcategoryId, 'sub');
    expect(provided.durationId, 'd');
    expect(provided.operatorId, 'o');
  });

  test('different url does not contain the same settings', () async {
    final SharedPreferencesSettingsProvider p1 = SharedPreferencesSettingsProvider(
      'url1',
      'loginName',
    );

    const Settings s = Settings(
      branchId: 'b',
      callerId: 'c',
      categoryId: 'cat',
      subcategoryId: 'sub',
      durationId: 'd',
      operatorId: 'o',
    );

    await p1.save(s);

    final SharedPreferencesSettingsProvider p2 = SharedPreferencesSettingsProvider(
      'url2',
      'loginName',
    );

    expect(await p2.provide(), null);
  });
}
