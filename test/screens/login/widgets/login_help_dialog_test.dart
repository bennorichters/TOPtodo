import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:toptodo/screens/login/widgets/login_help_dialog.dart';
import 'package:toptodo/constants/keys.dart' as ttd_keys;

import '../../../helper.dart';

void main() {
  group('LoginHelpDialog', () {
    testWidgets('plain text', (WidgetTester tester) async {
      await tester.pumpWidget(TestableWidgetWithMediaQuery(
        child: LoginHelpDialog(),
      ));

      final txt = find.byKey(Key(ttd_keys.loginHelpDialogUrlLauncher));
      expect(
        tester.widget<RichText>(txt).text.toPlainText(),
        'Fill in the TOPdesk address and your credentials. '
        'Note that the application password differs from your normal password. '
        'Read the online documentation for more details.',
      );
    });

    testWidgets('find link', (WidgetTester tester) async {
      await tester.pumpWidget(TestableWidgetWithMediaQuery(
        child: LoginHelpDialog(),
      ));

      var foundLink = false;
      final rt = find.byKey(Key(ttd_keys.loginHelpDialogUrlLauncher));
      tester.widget<RichText>(rt).text.visitChildren((visitor) {
        if (visitor is TextSpan && visitor.text == 'online documentation ') {
          foundLink = true;

          /// Calling for code coverage. Not sure how to test this does
          /// the right thing.
          (visitor.recognizer as TapGestureRecognizer).onTap();
        }
        return true;
      });

      expect(foundLink, true);
    });
  });
}
