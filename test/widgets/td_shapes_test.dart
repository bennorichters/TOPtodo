import 'dart:math' show pi;
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:toptodo/widgets/td_shapes.dart';

class MockCanvas extends Mock implements Canvas {}

void main() {
  testWidgets('better name needed', (WidgetTester tester) async {
    final TdShape tdShape = TdShape();

    final MockCanvas mockCanvas = MockCanvas();
    
    final Rect rect = Offset(-400, -400) & Size(800, 800);

    tdShape.paint(mockCanvas, const Size(400, 425));

    verify(
        mockCanvas.drawArc(rect, 0, argThat(closeTo(pi / 2, .01)), true, any));
  });
}
