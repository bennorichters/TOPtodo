import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:toptodo/screens/login/widgets/password_field.dart';
import 'package:toptodo/utils/keys.dart';

import '../../../helper.dart';

void main() {
  group('PasswordField', () {
    testWidgets('enter text', (WidgetTester tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(TestableWidgetWithMediaQuery(
        child: PasswordField(controller),
      ));

      final field = find.byKey(Key(TtdKeys.passwordFieldTextFormField));
      await tester.enterText(field, 's3Cret!');

      expect(controller.text, 's3Cret!');
    });

    testWidgets('obscured by default', (WidgetTester tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(TestableWidgetWithMediaQuery(
        child: PasswordField(controller),
      ));

      final widget = tester.widget<TextField>(find.byType(TextField));
      expect(widget.obscureText, isTrue);
    });

    testWidgets('not obscured after toggle', (WidgetTester tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(TestableWidgetWithMediaQuery(
        child: PasswordField(controller),
      ));


      final toggle = find.byKey(Key(TtdKeys.passwordFieldVisibleButton));
      await tester.tap(toggle);
      await tester.pump();

      final widget = tester.widget<TextField>(find.byType(TextField));
      expect(widget.obscureText, isFalse);
    });
  });
}
