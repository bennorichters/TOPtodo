import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:toptodo/blocs/init/bloc.dart';
import 'package:toptodo/screens/init/widgets/init_data_progress.dart';

import '../../../helper.dart';

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
        InitData(credentials: TestConstants.credentials),
      );

      expect(find.text(TestConstants.credentials.url), findsOneWidget);
      expect(find.text(TestConstants.credentials.loginName), findsOneWidget);
      expect(find.byIcon(Icons.done), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNWidgets(2));
    });

    testWidgets('credentials and settings done', (WidgetTester tester) async {
      await pumpInitDataProgress(
        tester,
        InitData(
            credentials: TestConstants.credentials,
            settings: TestConstants.settings),
      );

      expect(find.byIcon(Icons.done), findsNWidgets(2));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('credentials and operator done', (WidgetTester tester) async {
      await pumpInitDataProgress(
        tester,
        InitData(
            credentials: TestConstants.credentials,
            currentOperator: TestConstants.currentOperator),
      );

      expect(find.byIcon(Icons.done), findsNWidgets(2));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('all done', (WidgetTester tester) async {
      await pumpInitDataProgress(
        tester,
        InitData(
          credentials: TestConstants.credentials,
          settings: TestConstants.settings,
          currentOperator: TestConstants.currentOperator,
        ),
      );

      expect(find.byIcon(Icons.done), findsNWidgets(3));
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
