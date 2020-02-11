import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:toptodo/blocs/init/bloc.dart';
import 'package:toptodo/screens/init/widgets/init_data_progress.dart';

import '../../../helper.dart';

void main() {
  group('InitDataProgress', () {
    testWidgets('no data, 3 CircularProgressIndicators',
        (WidgetTester tester) async {
      final data = InitData.empty();
      await tester.pumpWidget(
        TestableWidgetWithMediaQuery(
          child: InitDataProgress(data),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
    });
  });
}
