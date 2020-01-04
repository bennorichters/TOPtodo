import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:toptodo/screens/login/login_screen.dart';
import 'package:toptodo/utils/colors.dart';

class MenuDialog extends StatelessWidget {
  const MenuDialog({@required this.showSettings});
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  iconSize: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    'TOPtodo',
                    style: TextStyle(
                      color: TdColors.materialDenim,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(width: 48),
              ],
            ),
            Divider(
              thickness: 1,
              indent: 10,
              endIndent: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 25),
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
