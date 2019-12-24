import 'package:flutter/material.dart';
import 'package:toptodo/screens/incident/incident_screen.dart';
import 'package:toptodo/screens/login/login_screen.dart';
import 'package:toptodo/screens/pre_login_screen/pre_login_screen.dart';
import 'package:toptodo/screens/settings/settings_screen.dart';
import 'package:toptodo_data/toptodo_data.dart';

class DataLoader extends StatelessWidget {
  DataLoader(
    this._credentialsProvider,
    this._topdeskProvider,
    this._settingsProvider,
  );
  final CredentialsProvider _credentialsProvider;
  final TopdeskProvider _topdeskProvider;
  final SettingsProvider _settingsProvider;
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_SavedData>(
      future: _retrieveSavedData(),
      builder: (
        BuildContext context,
        AsyncSnapshot<_SavedData> snapshot,
      ) {
        if (snapshot.hasData) {
          if (!snapshot.data.credentials.isComplete()) {
            return const LoginScreen();
          } else if (!snapshot.data.settings.isComplete()) {
            return const SettingsScreen();
          } else {
            return const IncidentScreen();
          }
        } else if (snapshot.hasError) {
          return PreLoginScreen(
            [
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              ),
            ],
          );
        } else {
          return const PreLoginScreen(
            [
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Waiting for saved data...'),
              ),
            ],
          );
        }
      },
    );
  }

  Future<_SavedData> _retrieveSavedData() async {
    final credentials = await _credentialsProvider.provide();
    if (!credentials.isComplete()) {
      return _SavedData(credentials, null);
    }

    _topdeskProvider.init(credentials);
    _settingsProvider.init(credentials.url, credentials.loginName);

    final settings = await _settingsProvider.provide();
    return _SavedData(credentials, settings);
  }
}

class _SavedData {
  _SavedData(this.credentials, this.settings);
  final Credentials credentials;
  final Settings settings;
}
