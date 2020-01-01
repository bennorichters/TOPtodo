import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:toptodo/blocs/login/bloc.dart';
import 'package:toptodo/blocs/login/login_bloc.dart';
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
                      color: denim.shade500,
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
                    const _MenuItem(
                      iconData: Icons.settings,
                      text: 'settings',
                      route: 'settings',
                    ),
                  if (showSettings) SizedBox(height: 20),
                  _MenuItem(
                    iconData: Icons.person,
                    text: 'log out',
                    route: 'login',
                    beforeNavigate: () {
                      BlocProvider.of<LoginBloc>(context).add(const LogOut());
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
    @required this.route,
    this.beforeNavigate,
    Key key,
  }) : super(key: key);
  final IconData iconData;
  final String text;
  final String route;
  final Function beforeNavigate;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (beforeNavigate != null) {
          beforeNavigate();
        }

        Navigator.pushReplacementNamed(context, route);
      },
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
