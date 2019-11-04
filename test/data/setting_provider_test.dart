import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toptopdo/data/model/settings.dart';
import 'package:toptopdo/data/settings_provider.dart';

void main() {
  test('first nothing then retrieve same as saved', () async {
    SharedPreferences.setMockInitialValues({});

    SharedPreferencesSettingsProvider p = SharedPreferencesSettingsProvider(
      'url',
      'loginName',
    );

    expect(await p.provide(), null);

    Settings s = Settings(
      branchId: 'b',
      callerId: 'c',
      categoryId: 'cat',
      subcategoryId: 'sub',
      durationId: 'd',
      operatorId: 'o',
    );

    await p.save(s);

    Settings provided = await p.provide();
    expect(provided.branchId, 'b');
    expect(provided.callerId, 'c');
    expect(provided.categoryId, 'cat');
    expect(provided.subcategoryId, 'sub');
    expect(provided.durationId, 'd');
    expect(provided.operatorId, 'o');
  });
}
