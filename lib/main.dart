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

void main() => runApp(TopToDoApp());

const int _denimPrimaryValue = 0xFF0A7DA0;

const Map<int, Color> _denimSwatch = <int, Color>{
  50: Color(0xFFE3F7FB),
  100: Color(0xFFC7EEF7),
  200: Color(0xFF76CFE3),
  300: Color(0xFF3EB1CC),
  400: Color(0xFF008EAF),
  500: Color(_denimPrimaryValue),
  600: Color(0xFF097090),
  700: Color(0xFF086480),
  800: Color(0xFF064B60),
  900: Color(0xFF043644),
};

const MaterialColor _denim = MaterialColor(_denimPrimaryValue, _denimSwatch);

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
          BlocProvider<TdModelSearchBloc>(
            builder: (BuildContext context) => TdModelSearchBloc(
              RepositoryProvider.of<TopdeskProvider>(context),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'TOPtodo',
          theme: ThemeData(
            primarySwatch: _denim,
          ),
          home: const LoginScreen(),
        ),
      ),
    );
  }
}
