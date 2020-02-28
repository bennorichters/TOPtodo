import 'package:flutter/material.dart';

class TdButton extends StatelessWidget {
  const TdButton({
    @required this.text,
    @required this.onTap,
    Key key,
  }) : super(key: key);

  final String text;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Image.asset('assets/button_denim.png'),
        Container(
          width: 230,
          height: 53,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onTap,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'BreeSerif',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
