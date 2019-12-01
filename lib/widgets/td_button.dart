import 'package:flutter/material.dart';

class TdButton extends StatelessWidget {
  const TdButton({@required this.text, @required this.onTap});
  final String text;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Image.asset('assets/button_denim.png'),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
