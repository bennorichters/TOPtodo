import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class TestableWidgetWithMediaQuery extends StatelessWidget {
  const TestableWidgetWithMediaQuery({
    this.child,
    this.width = 600,
    this.height = 800,
    this.routes,
  });

  final Widget child;
  final double width;
  final double height;
  final Map<String, WidgetBuilder> routes;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: routes ?? const <String, WidgetBuilder>{},
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
