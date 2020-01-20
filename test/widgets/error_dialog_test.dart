import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:toptodo/widgets/error_dialog.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  testWidgets('click to open error dialog', (WidgetTester tester) async {
    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(
      MaterialApp(
        home: _TestScreen(),
        routes: {
          'login': (context) => _TestLoginScreen(),
        },
        navigatorObservers: [mockObserver],
      ),
    );

    await tester.tap(find.text('Click me'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ok'));
    await tester.pumpAndSettle();

    expect(find.byType(_TestLoginScreen), findsOneWidget);

    verify(mockObserver.didPush(any, any));
  });
}

class _TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => ErrorDialog(
              cause: 'test error',
              activeScreenIsLogin: false,
            ),
          );
        },
        child: Text('Click me'),
      ),
    );
  }
}

class _TestLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text('LoginScreen'));
  }
}
