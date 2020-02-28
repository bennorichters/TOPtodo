import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:toptodo_data/toptodo_data.dart';

import 'package:toptodo/blocs/all_blocs.dart';
import 'package:toptodo/constants/colors.dart' as ttd_colors;
import 'package:toptodo/screens/all_screens.dart';

class TopToDoApp extends StatefulWidget {
  TopToDoApp({
    @required this.credentialsProvider,
    @required this.settingsProvider,
    @required this.topdeskProvider,
  });

  final CredentialsProvider credentialsProvider;
  final TopdeskProvider topdeskProvider;
  final SettingsProvider settingsProvider;

  @override
  State<StatefulWidget> createState() => _TopToDoAppState();
}

class _TopToDoAppState extends State<TopToDoApp> {
  @override
  void dispose() {
    widget.topdeskProvider.dispose();
    widget.settingsProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<IncidentBloc>(
          create: (BuildContext context) => IncidentBloc(
            topdeskProvider: widget.topdeskProvider,
            settingsProvider: widget.settingsProvider,
          ),
        ),
        BlocProvider<InitBloc>(
          create: (BuildContext context) => InitBloc(
            credentialsProvider: widget.credentialsProvider,
            settingsProvider: widget.settingsProvider,
            topdeskProvider: widget.topdeskProvider,
          ),
        ),
        BlocProvider<LoginBloc>(
          create: (BuildContext context) => LoginBloc(
            topdeskProvider: widget.topdeskProvider,
            credentialsProvider: widget.credentialsProvider,
            settingsProvider: widget.settingsProvider,
          ),
        ),
        BlocProvider<SettingsBloc>(
          create: (BuildContext context) => SettingsBloc(
            topdeskProvider: widget.topdeskProvider,
            settingsProvider: widget.settingsProvider,
          ),
        ),
        BlocProvider<TdModelSearchBloc>(
          create: (BuildContext context) => TdModelSearchBloc(
            topdeskProvider: widget.topdeskProvider,
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
                LoginScreen(logOut: args == null ? false : args.logOut),
          );
        },
        theme: ThemeData(
          primarySwatch: ttd_colors.materialDenim,
          fontFamily: 'OpenSans',
          appBarTheme: const AppBarTheme(
            textTheme: TextTheme(
              title: TextStyle(
                fontSize: 26.0,
                fontFamily: 'BreeSerif',
              ),
            ),
          ),
        ),
        home: const InitScreen(),
      ),
    );
  }
}
