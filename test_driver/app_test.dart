import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'package:toptodo/constants/keys.dart' as ttd_keys;

void main() {
  group('TopToDo App', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });

    test('error messages when nothing filled in', () async {
      await Future.delayed(Duration(milliseconds: 500));

      final buttonFinder = find.byValueKey(ttd_keys.credentialsFormLoginButton);
      await driver.tap(buttonFinder);

      const urlMsg = 'fill in the url of your TOPdesk environment';
      expect(await driver.getText(find.text(urlMsg)), urlMsg);

      const loginMsg = 'fill in your login name';
      expect(await driver.getText(find.text(loginMsg)), loginMsg);

      const passwordMsg = 'fill in your application password';
      expect(await driver.getText(find.text(passwordMsg)), passwordMsg);
    });

    test('succesfull login after filling in fields', () async {
      await driver.tap(find.byValueKey(ttd_keys.credentialsFormUrlField));
      await driver.enterText('theurl');

      await driver.tap(find.byValueKey(ttd_keys.credentialsFormLoginNameField));
      await driver.enterText('dawnm');

      await driver.tap(find.byValueKey(ttd_keys.passwordFieldTextFormField));
      await driver.enterText('s3cRet!');

      final buttonFinder = find.byValueKey(ttd_keys.credentialsFormLoginButton);
      await driver.tap(buttonFinder);
    });

    test('set fields in settings screen', () async {
      await driver.tap(find.byValueKey(ttd_keys.settingsFormSearchFieldBranch));
      await Future.delayed(Duration(milliseconds: 500));

      await driver.enterText('TOP');
      await Future.delayed(Duration(milliseconds: 500));

      await driver.tap(find.text('TOPdesk UK'));
    });
  });
}
