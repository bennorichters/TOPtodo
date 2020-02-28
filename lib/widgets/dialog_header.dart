import 'package:flutter/material.dart';
import 'package:toptodo/constants/colors.dart' as ttd_colors;

class DialogHeader extends StatelessWidget {
  const DialogHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
          iconSize: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            'TOPtodo',
            style: TextStyle(
              color: ttd_colors.materialDenim,
              fontFamily: 'BreeSerif',
              fontSize: 18,
            ),
          ),
        ),
        Container(width: 48),
      ],
    );
  }
}
