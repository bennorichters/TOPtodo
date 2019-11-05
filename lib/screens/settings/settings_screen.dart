import 'package:flutter/material.dart';
import 'package:toptopdo/data/model/credentials.dart';

class SettingsScreen extends StatefulWidget {
  final Credentials credentials;

  const SettingsScreen({
    Key key,
    @required this.credentials,
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
        child: Text('URL: ${widget.credentials.url}'),
      ),
    );
  }
}
