import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:toptodo/constants/keys.dart' as ttd_keys;
import 'package:toptodo/screens/all_screens.dart';
import 'package:toptodo/widgets/menu_operator_button.dart';

import '../test_constants.dart' as test_constants;
import '../test_helper.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('MenuDialog', () {
    testWidgets('show settings', (WidgetTester tester) async {
      await tester.pumpWidget(TestableWidgetWithMediaQuery(
        child: _TestOpenMenuDialogScreen(true),
      ));

      await tester.tap(find.byType(MenuOperatorButton));
      await tester.pump();

      expect(find.text('settings'), findsOneWidget);
    });

    testWidgets('dont show settings', (WidgetTester tester) async {
      await tester.pumpWidget(TestableWidgetWithMediaQuery(
        child: _TestOpenMenuDialogScreen(false),
      ));

      await tester.tap(find.byType(MenuOperatorButton));
      await tester.pump();

      expect(find.text('settings'), findsNothing);
    });

    testWidgets('navigate to settings', (WidgetTester tester) async {
      await tester.pumpWidget(TestableWidgetWithMediaQuery(
        routes: {'settings': (_) => TestScreen()},
        child: _TestOpenMenuDialogScreen(true),
      ));

      await tester.tap(find.byType(MenuOperatorButton));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();
      expect(find.byType(TestScreen), findsOneWidget);
    });

    testWidgets('logout', (WidgetTester tester) async {
      final observer = MockNavigatorObserver();

      await tester.pumpWidget(TestableWidgetWithMediaQuery(
        routes: {'login': (_) => TestScreen()},
        navigatorObservers: [observer],
        child: _TestOpenMenuDialogScreen(true),
      ));

      await tester.tap(find.byType(MenuOperatorButton));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.power_settings_new));
      await tester.pumpAndSettle();

      final capturedNewRoute = verify(observer.didReplace(
        newRoute: captureAnyNamed('newRoute'),
        oldRoute: anyNamed('oldRoute'),
      )).captured.single;

      LoginScreenArguments args = capturedNewRoute.settings.arguments;
      expect(args.logOut, isTrue);

      expect(find.byType(TestScreen), findsOneWidget);
    });

    testWidgets('find link', (WidgetTester tester) async {
      await tester.pumpWidget(TestableWidgetWithMediaQuery(
        child: _TestOpenMenuDialogScreen(false),
      ));

      await tester.tap(find.byType(MenuOperatorButton));
      await tester.pump();

      var foundLink = false;
      final richText = find.byKey(Key(ttd_keys.menuDialogRichText));

      tester.widget<RichText>(richText).text.visitChildren((visitor) {
        if (visitor is TextSpan && visitor.text == 'TOPtodo') {
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

class _TestOpenMenuDialogScreen extends StatelessWidget {
  _TestOpenMenuDialogScreen(this.showSettings);
  final bool showSettings;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MenuOperatorButton(
        test_constants.currentOperator,
        showSettings: showSettings,
      ),
    );
  }
}
