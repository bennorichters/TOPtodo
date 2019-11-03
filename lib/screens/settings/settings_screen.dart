import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final String loginName;

  const SettingsScreen({
    Key key,
    @required this.loginName,
  }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Container(
        child: Text('Welcome ${widget.loginName}!'),
      ),
    );
  }
}
