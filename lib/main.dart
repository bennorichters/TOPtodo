import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptodo/screens/login/login_screen.dart';
import 'package:bloc/bloc.dart';

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
  TopdeskProvider _topdeskProvider;

  @override
  void initState() {
    _topdeskProvider = FakeTopdeskProvider();
    super.initState();
  }

  @override
  void dispose() {
    _topdeskProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: <RepositoryProvider<dynamic>>[
        RepositoryProvider<CredentialsProvider>(
          create: (BuildContext context) => SecureStorageCredentials(),
        ),
        RepositoryProvider<SettingsProvider>(
          create: (BuildContext context) => SharedPreferencesSettingsProvider(
            _topdeskProvider,
          ),
        ),
        RepositoryProvider<TopdeskProvider>(
          create: (BuildContext context) => _topdeskProvider,
        )
      ],
      child: MultiBlocProvider(
        providers: <BlocProvider<Bloc<dynamic, dynamic>>>[
          BlocProvider<IncidentBloc>(
            create: (BuildContext context) => IncidentBloc(
              topdeskProvider: RepositoryProvider.of<TopdeskProvider>(context),
              settingsProvider:
                  RepositoryProvider.of<SettingsProvider>(context),
            ),
          ),
          BlocProvider<LoginBloc>(
            create: (BuildContext context) => LoginBloc(
              credentialsProvider:
                  RepositoryProvider.of<CredentialsProvider>(context),
              settingsProvider:
                  RepositoryProvider.of<SettingsProvider>(context),
              topdeskProvider: RepositoryProvider.of<TopdeskProvider>(context),
            ),
          ),
          BlocProvider<SettingsBloc>(
            create: (BuildContext context) => SettingsBloc(
              topdeskProvider: RepositoryProvider.of<TopdeskProvider>(context),
              settingsProvider:
                  RepositoryProvider.of<SettingsProvider>(context),
            ),
          ),
          BlocProvider<TdModelSearchBloc>(
            create: (BuildContext context) => TdModelSearchBloc(
              RepositoryProvider.of<TopdeskProvider>(context),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'TOPtodo',
          theme: ThemeData(
            primarySwatch: denim,
          ),
          home: const LoginScreen(),
        ),
      ),
    );
  }
}
