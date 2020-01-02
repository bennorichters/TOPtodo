import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptodo/screens/incident/incident_screen.dart';
import 'package:toptodo/screens/init/init_screen.dart';
import 'package:toptodo/screens/login/login_screen.dart';
import 'package:toptodo/screens/settings/settings_screen.dart';

import 'package:toptodo_data/toptodo_data.dart';
import 'package:toptodo_repository_providers_impl/toptodo_repository_providers_impl.dart';
import 'package:toptodo_topdesk_provider_mock/toptodo_topdesk_provider_mock.dart';

import 'blocs/all_blocs.dart';
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
    _settingsProvider = SharedPreferencesSettingsProvider();

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
        BlocProvider<InitBloc>(
          create: (BuildContext context) => InitBloc(
            credentialsProvider: _credentialsProvider,
            settingsProvider: _settingsProvider,
            topdeskProvider: _topdeskProvider,
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
        routes: {
          'incident': (context) => const IncidentScreen(),
          'settings': (context) => const SettingsScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name != 'login') {
            return null;
          }

          final LoginScreenArguments args = settings.arguments;
          return MaterialPageRoute(
            builder: (context) =>
                LoginScreen(logOut: args == null ? args.logOut : false),
          );
        },
        theme: ThemeData(primarySwatch: denim),
        home: InitScreen(),
      ),
    );
  }
}
