import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:toptodo/utils/keys.dart';
import 'package:toptodo/widgets/error_dialog.dart';
import 'package:toptodo_data/toptodo_data.dart';

void main() {
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
    await tester.tap(find.byKey(Key(TtdKeys.errorDialogOkButton)));
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
    await tester.tap(find.byKey(Key(TtdKeys.errorDialogOkButton)));
    await tester.pumpAndSettle();

    expect(Navigator.canPop(afterErrorScreenKey.currentContext), isFalse);
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
