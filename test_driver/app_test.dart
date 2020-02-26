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

      await driver.tap(find.byValueKey(ttd_keys.settingsFormSearchFieldCaller));
      await Future.delayed(Duration(milliseconds: 500));
      await driver.enterText('Dawn');
      await Future.delayed(Duration(milliseconds: 500));
      await driver.tap(find.text('Dawn Meadows'));

      await driver
          .tap(find.byValueKey(ttd_keys.settingsFormSearchFieldCategory));
      await Future.delayed(Duration(milliseconds: 500));
      await driver.tap(find.text('Personal'));

      await driver.tap(find.byValueKey(ttd_keys.subcategorySearchList));
      await Future.delayed(Duration(milliseconds: 500));
      await driver.tap(find.text('Todo'));

      await driver
          .tap(find.byValueKey(ttd_keys.settingsFormSearchFieldDuration));
      await Future.delayed(Duration(milliseconds: 500));
      await driver.tap(find.text('1 day'));

      await driver.tap(find.text('save'));
    });

    test('submit todo', () async {
      final briefDescription = 'Call Peter';
      final request = 'Discuss:\\n- Team outing\\n- Budget';

      await driver.tap(find.byValueKey(ttd_keys.incidentBriefDescriptionField));
      await driver.enterText(briefDescription);

      await driver.tap(find.byValueKey(ttd_keys.incidentRequestField));
      await driver.enterText(request);

      await driver.tap(find.byValueKey(ttd_keys.incidentSubmitButton));

      await Future.delayed(Duration(milliseconds: 500));

      expect(
        await driver.requestData('lastBriefdescription'),
        briefDescription,
      );
      expect(await driver.requestData('lastRequest'), request);
    });
  });
}
