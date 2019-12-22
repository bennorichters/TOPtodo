
import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:toptodo/utils/colors.dart' show forest100;

class TdShape extends CustomPainter {
  static const Offset _bottomMargin = Offset(0, 25);
  static final Paint _paint = Paint()..color = forest100;

  @override
  void paint(Canvas canvas, Size size) {
    final Size drawSize = size - _bottomMargin as Size;
    if (drawSize.aspectRatio >= 1) {
      _small(canvas, drawSize);
    } else if (drawSize.aspectRatio >= .6) {
      _medium(canvas, drawSize);
    } else {
      _long(canvas, drawSize);
    }
  }

  void _small(Canvas canvas, Size size) {
   canvas.drawCircle(Offset.zero, size.shortestSide, _paint); 
  }

  void _medium(Canvas canvas, Size size) {
    final double radius = min(size.width, size.height / 2);
    canvas.drawCircle(Offset(0, radius), radius, _paint);
    canvas.drawRect(Offset.zero & Size.fromRadius(radius / 2), _paint);
  }

  void _long(Canvas canvas, Size size) {
    final double radius = min(size.width, size.height / 3);
    final double circleCenter = size.height - radius;
    canvas.drawCircle(Offset(0, circleCenter), radius, _paint);
    canvas.drawRect(Offset.zero & Size(radius, circleCenter), _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
