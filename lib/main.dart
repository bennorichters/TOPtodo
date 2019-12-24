import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptodo/screens/incident/incident_screen.dart';
import 'package:toptodo/screens/login/login_screen.dart';
import 'package:toptodo/screens/pre_login_screen/pre_login_screen.dart';
import 'package:toptodo/screens/settings/settings_screen.dart';

import 'package:toptodo_data/toptodo_data.dart';
import 'package:toptodo_repository_providers_impl/toptodo_repository_providers_impl.dart';
import 'package:toptodo_topdesk_provider_mock/toptodo_topdesk_provider_mock.dart';

import 'blocs/incident/incident_bloc.dart';
import 'blocs/login/login_bloc.dart';
import 'blocs/settings/bloc.dart';
import 'blocs/td_model_search/bloc.dart';

import 'utils/colors.dart';

void main() => runApp(TopToDoApp());

class TopToDoApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TopToDoAppState();
}

class _TopToDoAppState extends State<TopToDoApp> {
  CredentialsProvider _credentialsProvider;
  TopdeskProvider _topdeskProvider;
  SettingsProvider _settingsProvider;

  @override
  void initState() {
    _credentialsProvider = SecureStorageCredentials();
    _topdeskProvider = FakeTopdeskProvider();
    _settingsProvider = SharedPreferencesSettingsProvider(_topdeskProvider);

    super.initState();
  }

  @override
  void dispose() {
    _topdeskProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<IncidentBloc>(
          create: (BuildContext context) => IncidentBloc(
            topdeskProvider: _topdeskProvider,
            settingsProvider: _settingsProvider,
          ),
        ),
        BlocProvider<LoginBloc>(
          create: (BuildContext context) => LoginBloc(
            topdeskProvider: _topdeskProvider,
            credentialsProvider: _credentialsProvider,
            settingsProvider: _settingsProvider,
          ),
        ),
        BlocProvider<SettingsBloc>(
          create: (BuildContext context) => SettingsBloc(
            topdeskProvider: _topdeskProvider,
            settingsProvider: _settingsProvider,
          ),
        ),
        BlocProvider<TdModelSearchBloc>(
          create: (BuildContext context) => TdModelSearchBloc(
            topdeskProvider: _topdeskProvider,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'TOPtodo',
        theme: ThemeData(
          primarySwatch: denim,
        ),
        home: FutureBuilder<_SavedData>(
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
        ),
      ),
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
