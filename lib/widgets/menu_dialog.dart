import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

class MenuDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _MenuItem(
                    iconData: Icons.settings,
                    text: 'settings',
                    route: 'settings',
                  ),
                  SizedBox(height: 20),
                  const _MenuItem(
                    iconData: Icons.person,
                    text: 'log out',
                    route: 'login',
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
    Key key,
  }) : super(key: key);
  final IconData iconData;
  final String text;
  final String route;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushReplacementNamed(context, route),
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
