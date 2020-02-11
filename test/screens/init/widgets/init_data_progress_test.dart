import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:toptodo/blocs/init/bloc.dart';
import 'package:toptodo/screens/init/widgets/init_data_progress.dart';
import 'package:toptodo_data/toptodo_data.dart';

import '../../../helper.dart';

void main() {
  group('InitDataProgress', () {
    const credentials = Credentials(
      url: 'the url',
      loginName: 'the loginname',
      password: 's3cret!',
    );

    const settings = Settings();

    const currentOperator = TdOperator(
      id: 'a',
      name: 'a',
      firstLine: true,
      secondLine: true,
    );

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
        InitData(credentials: credentials),
      );

      expect(find.text('the url'), findsOneWidget);
      expect(find.text('the loginname'), findsOneWidget);
      expect(find.byIcon(Icons.done), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNWidgets(2));
    });

    testWidgets('credentials and settings done', (WidgetTester tester) async {
      await pumpInitDataProgress(
        tester,
        InitData(credentials: credentials, settings: settings),
      );

      expect(find.byIcon(Icons.done), findsNWidgets(2));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('credentials and operator done', (WidgetTester tester) async {
      await pumpInitDataProgress(
        tester,
        InitData(credentials: credentials, currentOperator: currentOperator),
      );

      expect(find.byIcon(Icons.done), findsNWidgets(2));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('all done', (WidgetTester tester) async {
      await pumpInitDataProgress(
        tester,
        InitData(
          credentials: credentials,
          settings: settings,
          currentOperator: currentOperator,
        ),
      );

      expect(find.byIcon(Icons.done), findsNWidgets(3));
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
