import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptopdo/repository_providers_api/repository_providers_api.dart';
import 'package:toptopdo/repository_providers_impl/credentials_provider.dart';
import 'package:toptopdo/repository_providers_impl/settings_provider.dart';
import 'package:toptopdo/repository_providers_impl/topdesk_provider.dart';
import 'package:toptopdo/screens/login/bloc/bloc.dart';
import 'package:toptopdo/screens/login/login_screen.dart';
import 'package:toptopdo/screens/settings/bloc/settings_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:toptopdo/screens/settings/branch_search/bloc/bloc.dart';

void main() => runApp(TopToDoApp());

class TopToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: <RepositoryProvider<dynamic>>[
        RepositoryProvider<CredentialsProvider>(
          builder: (BuildContext context) => SecureStorageCredentials(),
        ),
        RepositoryProvider<SettingsProviderFactory>(
          builder: (BuildContext context) => (String url, String loginName) =>
              SharedPreferencesSettingsProvider(url, loginName),
        ),
        RepositoryProvider<TopdeskProvider>(
          builder: (BuildContext context) => FakeTopdeskProvider(),
        )
      ],
      child: MultiBlocProvider(
        providers: <BlocProvider<Bloc<dynamic, dynamic>>>[
          BlocProvider<LoginBloc>(
            builder: (BuildContext context) => LoginBloc(
              credentialsProvider:
                  RepositoryProvider.of<CredentialsProvider>(context),
              settingsProviderFactory:
                  RepositoryProvider.of<SettingsProviderFactory>(context),
              topdeskProvider: RepositoryProvider.of<TopdeskProvider>(context),
            ),
          ),
          BlocProvider<SettingsBloc>(
            builder: (BuildContext context) => SettingsBloc(
              RepositoryProvider.of<TopdeskProvider>(context),
            ),
          ),
          BlocProvider<BranchSearchBloc>(
            builder: (BuildContext context) => BranchSearchBloc(
              RepositoryProvider.of<TopdeskProvider>(context),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'TOPtodo',
          home: const LoginScreen(),
        ),
      ),
    );
  }
}