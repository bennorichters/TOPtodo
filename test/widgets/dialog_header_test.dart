import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:toptodo/blocs/incident/bloc.dart';
import 'package:toptodo/widgets/menu_dialog.dart';

import '../test_constants.dart' as test_constants;
import '../test_helper.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockIncidentBloc extends MockBloc<IncidentEvent, IncidentState>
    implements IncidentBloc {}

void main() {
  group('DialogHeader', () {
    testWidgets('open and close dialog',
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
                  builder: (context) => MenuDialog(
                    currentOperator: test_constants.currentOperator,
                    showSettings: false,
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
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      verify(observer.didPop(any, any)).called(1);
    });
  });
}
