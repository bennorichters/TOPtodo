import 'package:flutter/material.dart';

const _sidePadding = 50.0;

class LandscapePadding extends StatelessWidget {
  const LandscapePadding({this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
          orientation == Orientation.landscape ? _sidePadding : 0,
          0,
          orientation == Orientation.landscape ? _sidePadding : 0,
          0,
        ),
        child: child,
      );
    });
  }
}
