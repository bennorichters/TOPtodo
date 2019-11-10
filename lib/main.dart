import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptopdo/data/settings_provider.dart';
import 'package:toptopdo/data/topdesk_api_provider.dart';
import 'package:toptopdo/screens/login/bloc/bloc.dart';
import 'package:toptopdo/screens/login/login_screen.dart';
import 'package:toptopdo/screens/settings/bloc/settings_bloc.dart';

import 'data/credentials_provider.dart';

void main() => runApp(TopToDoApp());

class TopToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CredentialsProvider>(
          builder: (context) => SecureStorageCredentials(),
        ),
        RepositoryProvider<SettingsProviderFactory>(
          builder: (context) => (url, loginName) =>
              SharedPreferencesSettingsProvider(url, loginName),
        ),
        RepositoryProvider<TopdeskProvider>(
          builder: (context) => ApiTopdeskProvider(),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LoginBloc>(
            builder: (context) => LoginBloc(
              credentialsProvider:
                  RepositoryProvider.of<CredentialsProvider>(context),
              settingsProviderFactory:
                  RepositoryProvider.of<SettingsProviderFactory>(context),
              topdeskProvider: RepositoryProvider.of<TopdeskProvider>(context),
            ),
          ),
          BlocProvider<SettingsBloc>(
            builder: (context) => SettingsBloc(
              RepositoryProvider.of<TopdeskProvider>(context),
            ),
          )
        ],
        child: MaterialApp(
          title: 'TOPtodo',
          home: LoginScreen(),
        ),
      ),
    );
  }
}
