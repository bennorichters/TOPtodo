import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:toptodo/blocs/init/bloc.dart';
import 'package:toptodo/screens/init/widgets/init_data_progress.dart';

import '../../../test_helper.dart';
import '../../../test_constants.dart' as test_constants;

void main() {
  group('InitDataProgress', () {
    void pumpInitDataProgress(WidgetTester tester, InitData data) async {
      await tester.pumpWidget(
        TestableWidgetWithMediaQuery(
          child: InitDataProgress(data),
        ),
      );
    }

    testWidgets('no data', (WidgetTester tester) async {
      await pumpInitDataProgress(tester, InitData.empty());

      expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
    });

    testWidgets('credentials done', (WidgetTester tester) async {
      await pumpInitDataProgress(
        tester,
        InitData(credentials: test_constants.credentials),
      );

      expect(find.text(test_constants.credentials.url), findsOneWidget);
      expect(find.text(test_constants.credentials.loginName), findsOneWidget);
      expect(find.byIcon(Icons.done), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNWidgets(2));
    });

    testWidgets('credentials and settings done', (WidgetTester tester) async {
      await pumpInitDataProgress(
        tester,
        InitData(
            credentials: test_constants.credentials,
            settings: test_constants.settings),
      );

      expect(find.byIcon(Icons.done), findsNWidgets(2));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('credentials and operator done', (WidgetTester tester) async {
      await pumpInitDataProgress(
        tester,
        InitData(
            credentials: test_constants.credentials,
            currentOperator: test_constants.currentOperator),
      );

      expect(find.byIcon(Icons.done), findsNWidgets(2));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('all done', (WidgetTester tester) async {
      await pumpInitDataProgress(
        tester,
        InitData(
          credentials: test_constants.credentials,
          settings: test_constants.settings,
          currentOperator: test_constants.currentOperator,
        ),
      );

      expect(find.byIcon(Icons.done), findsNWidgets(3));
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
