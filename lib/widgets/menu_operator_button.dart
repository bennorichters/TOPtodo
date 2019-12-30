import 'package:flutter/material.dart';
import 'package:toptodo/widgets/menu_dialog.dart';
import 'package:toptodo/widgets/td_model_avatar.dart';
import 'package:toptodo_data/toptodo_data.dart';

class MenuOperatorButton extends StatelessWidget {
  const MenuOperatorButton(
    this.incidentOperator, {
    this.showSettings = true,
  });
  final IncidentOperator incidentOperator;
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
              showSettings: showSettings,
            ),
          );
        },
        child: TdModelAvatar(
          incidentOperator,
          diameter: 25.0,
        ),
      ),
    );
  }
}
