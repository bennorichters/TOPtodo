import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'package:toptodo/utils/keys.dart';

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

    test('...', () async {
      await Future.delayed(Duration(seconds: 2));

      final buttonFinder = find.byValueKey(TtdKeys.credentialsFormLoginButton);
      await driver.tap(buttonFinder);

      const loginMsg = 'fill in your login name';
      final textFinder = find.text(loginMsg);
      expect(await driver.getText(textFinder), loginMsg);
    });
  });
}
