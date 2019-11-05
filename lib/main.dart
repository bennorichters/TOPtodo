import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptopdo/data/settings_provider.dart';
import 'package:toptopdo/screens/login/bloc/bloc.dart';
import 'package:toptopdo/screens/login/login_screen.dart';

import 'data/credentials_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<CredentialsProvider>(
            builder: (context) => SecureStorageCredentials(),
          ),
          RepositoryProvider<SettingsProviderFactory>(
            builder: (context) => (url, loginName) =>
                SharedPreferencesSettingsProvider(url, loginName),
          ),
        ],
        child: BlocProvider(
          builder: (context) => LoginBloc(
            credentialsProvider:
                RepositoryProvider.of<CredentialsProvider>(context),
            settingsProviderFactory:
                RepositoryProvider.of<SettingsProviderFactory>(context),
          ),
          child: LoginScreen(),
        ),
      ),
    );
  }
}
