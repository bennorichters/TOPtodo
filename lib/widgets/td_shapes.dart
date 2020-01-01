import 'dart:math' show min, pi;

import 'package:flutter/material.dart';
import 'package:toptodo/utils/colors.dart' show forest100;

enum LongSide { top, right, bottom, left }

class TdShape extends CustomPainter {
  const TdShape(this.longSide);
  final LongSide longSide;

  @override
  void paint(Canvas canvas, Size size) {
    var xSize = size;
    if (longSide == LongSide.top) {
      canvas.translate(size.width, 0);
      canvas.rotate(pi / 2);
      xSize = size.flipped;
    } else if (longSide == LongSide.right) {
      canvas.scale(-1, 1);
      canvas.translate(-size.width, 0);
    } else if (longSide == LongSide.bottom) {
      canvas.translate(size.width, size.height);
      canvas.rotate(pi / 2);
      canvas.scale(-1, 1);
      xSize = size.flipped;
    }

    _TdShapeCalculator(canvas, xSize).paint();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _TdShapeCalculator {
  const _TdShapeCalculator(this.canvas, Size screenSize)
      : size = screenSize - _bottomMargin;
  final Canvas canvas;
  final Size size;

  static const _bottomMargin = Offset(0, 25);
  static final _paint = Paint()..color = forest100;

  void paint() {
    if (size.aspectRatio >= 1) {
      _small();
    } else if (size.aspectRatio >= .6) {
      _medium();
    } else {
      _long();
    }
  }

  void _small() {
    canvas.drawCircle(Offset.zero, size.shortestSide, _paint);
  }

  void _medium() {
    final radius = min(size.width, size.height / 2);
    canvas.drawCircle(Offset(0, radius), radius, _paint);
    canvas.drawRect(Offset.zero & Size.fromRadius(radius / 2), _paint);
  }

  void _long() {
    final radius = min(size.width, size.height / 3);
    final circleCenter = size.height - radius;
    canvas.drawCircle(Offset(0, circleCenter), radius, _paint);
    canvas.drawRect(Offset.zero & Size(radius, circleCenter), _paint);
  }
}
