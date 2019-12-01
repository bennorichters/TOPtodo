import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptodo/screens/login/login_screen.dart';
import 'package:bloc/bloc.dart';

import 'package:toptodo_data/toptodo_data.dart';
import 'package:toptodo_repository_providers_impl/toptodo_repository_providers_impl.dart';
import 'package:toptodo_topdesk_provider_mock/toptodo_topdesk_provider_mock.dart';

import 'blocs/login/bloc.dart';
import 'blocs/settings/bloc.dart';
import 'blocs/td_model_search/bloc.dart';

import 'utils/colors.dart';

void main() => runApp(TopToDoApp());

class TopToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: <RepositoryProvider<dynamic>>[
        RepositoryProvider<CredentialsProvider>(
          create: (BuildContext context) => SecureStorageCredentials(),
        ),
        RepositoryProvider<SettingsProviderFactory>(
          create: (BuildContext context) => (String url, String loginName) =>
              SharedPreferencesSettingsProvider(url, loginName),
        ),
        RepositoryProvider<TopdeskProvider>(
          create: (BuildContext context) => FakeTopdeskProvider(),
        )
      ],
      child: MultiBlocProvider(
        providers: <BlocProvider<Bloc<dynamic, dynamic>>>[
          BlocProvider<LoginBloc>(
            create: (BuildContext context) => LoginBloc(
              credentialsProvider:
                  RepositoryProvider.of<CredentialsProvider>(context),
              settingsProviderFactory:
                  RepositoryProvider.of<SettingsProviderFactory>(context),
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
