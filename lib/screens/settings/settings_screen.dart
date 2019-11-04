import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final String url;

  const SettingsScreen({
    Key key,
    @required this.url,
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
        child: Text('URL: ${widget.url}'),
      ),
    );
  }
}
