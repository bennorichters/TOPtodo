import 'dart:math' show pi;
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:toptodo/widgets/td_shapes.dart';

class MockCanvas extends Mock implements Canvas {}

void main() {
  testWidgets('square canvas', (WidgetTester tester) async {
    final MockCanvas mockCanvas = MockCanvas();
    final TdShape tdShape = TdShape();
    tdShape.paint(mockCanvas, const Size(400, 425));

    verify(
      mockCanvas.drawArc(
        _squaredRect(400),
        0,
        argThat(closeTo(pi / 2, .01)),
        true,
        any,
      ),
    );
    verifyNever(mockCanvas.drawRect(any, any));
  });
}

// Work around to get rid of "const" lint warning
Rect _squaredRect(double radius) =>
    Offset(-radius, -radius) & Size(2 * radius, 2 * radius);
