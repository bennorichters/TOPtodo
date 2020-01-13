import 'package:flutter/gestures.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:toptodo/screens/login/login_screen.dart';
import 'package:toptodo/utils/td_colors.dart';
import 'package:toptodo/widgets/dialog_header.dart';
import 'package:toptodo/widgets/td_model_avatar.dart';
import 'package:toptodo_data/toptodo_data.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuDialog extends StatelessWidget {
  const MenuDialog({
    @required this.currentOperator,
    @required this.showSettings,
  });

  final TdOperator currentOperator;
  final bool showSettings;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DialogHeader(),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TdModelAvatar(
                    currentOperator,
                    diameter: 35,
                  ),
                  const SizedBox(width: 20),
                  Text(currentOperator.name),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              indent: 10,
              endIndent: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showSettings)
                    _MenuItem(
                      iconData: Icons.settings,
                      text: 'settings',
                      onTap: () {
                        Navigator.pushReplacementNamed(context, 'settings');
                      },
                    ),
                  if (showSettings) SizedBox(height: 20),
                  _MenuItem(
                    iconData: Icons.power_settings_new,
                    text: 'log out',
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        'login',
                        arguments: LoginScreenArguments(logOut: true),
                      );
                    },
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              indent: 10,
              endIndent: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'TOPtodo ',
                          style: TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launch(
                                'https://github.com/bennorichters/toptodo',
                              );
                            },
                        ),
                        TextSpan(
                          text: 'is an open source project.',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    @required this.iconData,
    @required this.text,
    this.onTap,
    Key key,
  }) : super(key: key);
  final IconData iconData;
  final String text;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(iconData),
          ),
          Text(text),
        ],
      ),
    );
  }
}
