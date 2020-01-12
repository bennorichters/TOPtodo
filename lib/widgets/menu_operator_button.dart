import 'package:flutter/material.dart';
import 'package:toptodo/widgets/menu_dialog.dart';
import 'package:toptodo/widgets/td_model_avatar.dart';
import 'package:toptodo_data/toptodo_data.dart';

class MenuOperatorButton extends StatelessWidget {
  const MenuOperatorButton(
    this.tdOperator, {
    this.showSettings = true,
  });
  final TdOperator tdOperator;
  final bool showSettings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => MenuDialog(
              currentOperator: tdOperator,
              showSettings: showSettings,
            ),
          );
        },
        child: TdModelAvatar(
          tdOperator,
          diameter: 30.0,
        ),
      ),
    );
  }
}
