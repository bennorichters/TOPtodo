import 'package:flutter/material.dart';

const _sidePadding = 50.0;

class LandscapePadding extends StatelessWidget {
  const LandscapePadding({this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final landscape =
        (MediaQuery.of(context).orientation == Orientation.landscape);
        
    return Padding(
      padding: EdgeInsets.fromLTRB(
        landscape ? _sidePadding : 0,
        0,
        landscape ? _sidePadding : 0,
        0,
      ),
      child: child,
    );
  }
}
