import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:toptodo/screens/login/widgets/login_help_dialog.dart';
import 'package:toptodo/utils/keys.dart';

import '../../../helper.dart';

void main() {
  group('LoginHelpDialog', () {
    testWidgets('find link', (WidgetTester tester) async {
      await tester.pumpWidget(TestableWidgetWithMediaQuery(
        child: LoginHelpDialog(),
      ));

      final txt = find.byKey(Key(TtdKeys.loginHelpDialogUrlLauncher));
      expect(
        tester.widget<RichText>(txt).text.toPlainText(),
        'Fill in the TOPdesk address and your credentials. '
        'Note that the application password differs from your normal password. '
        'Read the online documentation for more details.',
      );
    });
  });
}
