
import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:toptodo/utils/colors.dart';

class TdShape extends CustomPainter {
  static const int _bottomMargin = 25;
  static final Paint _paint = Paint()..color = forest100;

  @override
  void paint(Canvas canvas, Size size) {
    final double ratio = size.width / (size.height - _bottomMargin);
    if (ratio >= 1) {
      quarterCircle(size, canvas);
    } else if (ratio >= .6) {
      mediumShape(size, canvas);
    } else {
      longShape(size, canvas);
    }
  }

  void quarterCircle(Size size, Canvas canvas) {
    final double radius = size.height - _bottomMargin;
    final Rect rect = Offset(-radius, -radius) & Size(radius * 2, radius * 2);
    canvas.drawArc(rect, 0, pi / 2, true, _paint);
  }

  void mediumShape(Size size, Canvas canvas) {
    final double radius = size.width - _bottomMargin;
    final Rect rect = Offset(-radius, 0) & Size(radius * 2, radius * 2);

    canvas.drawArc(rect, 0, pi / 2, true, _paint);
    canvas.drawRect(const Offset(0, 0) & Size(radius, radius), _paint);
  }

  void longShape(Size size, Canvas canvas) {
    final double radius = (size.height - _bottomMargin) / 3;
    final double blockHeight = size.height - _bottomMargin - radius;

    final Rect rect =
        Offset(-radius, blockHeight - radius) & Size(2 * radius, 2 * radius);
    canvas.drawArc(rect, 0, pi / 2, true, _paint);

    canvas.drawRect(const Offset(0, 0) & Size(radius, blockHeight), _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
