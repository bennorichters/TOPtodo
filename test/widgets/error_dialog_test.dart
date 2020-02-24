import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:toptodo/constants/keys.dart' as ttd_keys;
import 'package:toptodo/widgets/error_dialog.dart';
import 'package:toptodo_data/toptodo_data.dart';

import '../test_helper.dart';

class MockStackTrace extends Mock implements StackTrace {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('ErrorDialog', () {
    testWidgets('closing error dialog puts only login screen on stack',
        (WidgetTester tester) async {
      final afterErrorScreenKey = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: _TestOpenErrorDialogScreen(
            'unspecified error that redirects to login screen',
          ),
          routes: {
            'login': (context) => _TestAfterErrorScreen(afterErrorScreenKey),
          },
        ),
      );

      await tester.tap(find.byKey(Key('test_open_error_dialog')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key(ttd_keys.errorDialogOkButton)));
      await tester.pumpAndSettle();

      expect(Navigator.canPop(afterErrorScreenKey.currentContext), isFalse);
    });

    testWidgets('closing error dialog puts only settings screen on stack',
        (WidgetTester tester) async {
      final afterErrorScreenKey = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: _TestOpenErrorDialogScreen(
            TdBadRequestException('error that redirects to settings screen'),
          ),
          routes: {
            'settings': (context) => _TestAfterErrorScreen(afterErrorScreenKey),
          },
        ),
      );

      await tester.tap(find.byKey(Key('test_open_error_dialog')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key(ttd_keys.errorDialogOkButton)));
      await tester.pumpAndSettle();

      expect(Navigator.canPop(afterErrorScreenKey.currentContext), isFalse);
    });

    testWidgets('close dialog for login screen only pops',
        (WidgetTester tester) async {
      final observer = MockNavigatorObserver();

      await tester.pumpWidget(
        TestableWidgetWithMediaQuery(
          navigatorObservers: [observer],
          child: Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => ErrorDialog(
                    cause: 'just testing',
                    stackTrace: StackTrace.current,
                    activeScreenIsLogin: true,
                  ),
                );
              },
              child: Text('open dialog'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open dialog'));
      await tester.pump();
      await tester.tap(find.byKey(Key(ttd_keys.errorDialogOkButton)));
      await tester.pump();

      verify(observer.didPop(any, any)).called(1);
    });

    testWidgets('view details', (WidgetTester tester) async {
      final mockStackTrace = MockStackTrace();

      await tester.pumpWidget(TestableWidgetWithMediaQuery(
        child: ErrorDialog(
          cause: 'error',
          stackTrace: mockStackTrace,
          activeScreenIsLogin: true,
        ),
      ));

      await tester.tap(find.text('View details...'));
      await tester.pump();
      expect(find.text('MockStackTrace'), findsOneWidget);
    });

    testWidgets('copy error', (WidgetTester tester) async {
      await tester.pumpWidget(TestableWidgetWithMediaQuery(
        child: ErrorDialog(
          cause: 'error',
          stackTrace: StackTrace.current,
          activeScreenIsLogin: true,
        ),
      ));

      await tester.tap(find.text('View details...'));
      await tester.pump();
      await tester.tap(find.text('Copy error'));

      // not sure how to test if error is copied to clipboard
      // see: https://github.com/flutter/flutter/issues/47448
    });
  });
}

class _TestOpenErrorDialogScreen extends StatelessWidget {
  _TestOpenErrorDialogScreen(this._errorToThrow);
  final Object _errorToThrow;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        key: Key('test_open_error_dialog'),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => ErrorDialog(
              cause: _errorToThrow,
              stackTrace: StackTrace.current,
              activeScreenIsLogin: false,
            ),
          );
        },
        child: Container(),
      ),
    );
  }
}

class _TestAfterErrorScreen extends StatelessWidget {
  _TestAfterErrorScreen(GlobalKey key) : super(key: key);

  @override
  Widget build(BuildContext context) => Container();
}
