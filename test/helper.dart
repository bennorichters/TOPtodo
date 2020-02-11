import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class TestableWidgetWithMediaQuery extends StatelessWidget {
  const TestableWidgetWithMediaQuery({
    this.child,
    this.width = 600,
    this.height = 800,
  });

  final Widget child;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: MediaQuery(
          data: MediaQueryData.fromWindow(ui.window).copyWith(
            size: Size(width, height),
          ),
          child: child,
        ),
      ),
    );
  }
}
