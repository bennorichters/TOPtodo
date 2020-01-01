import 'dart:math' show min, pi;
import 'package:flutter/material.dart';

enum LongSide { top, right, bottom, left }

class TdShape extends CustomPainter {
  const TdShape(this.longSide, this.color);
  final LongSide longSide;
  final Color color;

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

    _TdShapeCalculator(canvas, xSize, color).paint();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _TdShapeCalculator {
  _TdShapeCalculator(this.canvas, Size screenSize, color)
      : size = screenSize - _bottomMargin,
        paintWithColor = Paint()..color = color;
  final Canvas canvas;
  final Size size;

  static const _bottomMargin = Offset(0, 25);
  final paintWithColor;

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
    canvas.drawCircle(Offset.zero, size.shortestSide, paintWithColor);
  }

  void _medium() {
    final radius = min(size.width, size.height / 2);
    canvas.drawCircle(Offset(0, radius), radius, paintWithColor);
    canvas.drawRect(Offset.zero & Size.fromRadius(radius / 2), paintWithColor);
  }

  void _long() {
    final radius = min(size.width, size.height / 3);
    final circleCenter = size.height - radius;
    canvas.drawCircle(Offset(0, circleCenter), radius, paintWithColor);
    canvas.drawRect(Offset.zero & Size(radius, circleCenter), paintWithColor);
  }
}
