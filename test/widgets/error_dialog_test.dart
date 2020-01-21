import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:toptodo/widgets/error_dialog.dart';
import 'package:toptodo_data/toptodo_data.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  testWidgets('closing error dialog puts only login screen on stack',
      (WidgetTester tester) async {
    final key = GlobalKey();

    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(
      MaterialApp(
        home: _TestScreen('unspecified error that redirects to login screen'),
        routes: {
          'login': (context) => _TestAfterErrorScreen(key),
        },
        navigatorObservers: [mockObserver],
      ),
    );

    await tester.tap(find.byKey(Key('test_open_error_dialog')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key(ErrorDialog.keyNameOkButton)));
    await tester.pumpAndSettle();

    expect(Navigator.canPop(key.currentContext), isFalse);
  });

  testWidgets('closing error dialog puts only settings screen on stack',
      (WidgetTester tester) async {
    final key = GlobalKey();

    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(
      MaterialApp(
        home: _TestScreen(TdBadRequestException(
          'error that redirects to settings screen',
        )),
        routes: {
          'settings': (context) => _TestAfterErrorScreen(key),
        },
        navigatorObservers: [mockObserver],
      ),
    );

    await tester.tap(find.byKey(Key('test_open_error_dialog')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key(ErrorDialog.keyNameOkButton)));
    await tester.pumpAndSettle();

    expect(Navigator.canPop(key.currentContext), isFalse);
  });
}

class _TestScreen extends StatelessWidget {
  _TestScreen(this._errorToThrow);
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
  Widget build(BuildContext context) {
    return Container(child: Text('LoginScreen'));
  }
}
