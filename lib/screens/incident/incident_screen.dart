import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptodo/blocs/incident/bloc.dart';
import 'package:toptodo/blocs/login/bloc.dart';
import 'package:toptodo/screens/login/login_screen.dart';
import 'package:toptodo/screens/settings/settings_screen.dart';

class IncidentScreen extends StatefulWidget {
  const IncidentScreen({Key key}) : super(key: key);

  @override
  _IncidentScreenState createState() => _IncidentScreenState();
}

class _IncidentScreenState extends State<IncidentScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<IncidentBloc>(context)..add(IncidentShowForm());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (_) {
              BlocProvider.of<IncidentBloc>(context)
                ..add(IncidentShowSettingsEvent());
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: '0',
                  child: Text('settings'),
                )
              ];
            },
          ),
          PopupMenuButton<String>(
            onSelected: (_) {
              BlocProvider.of<IncidentBloc>(context)
                ..add(IncidentLogOutEvent());
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: '1',
                  child: Text('log out'),
                )
              ];
            },
          ),
        ],
      ),
      body: BlocListener<IncidentBloc, IncidentState>(
        listener: (BuildContext context, IncidentState state) {
          if (state is IncidentLogOutState) {
            BlocProvider.of<LoginBloc>(context)..add(const AppStarted());

            Navigator.of(context).pushReplacement<dynamic, LoginScreen>(
              MaterialPageRoute<LoginScreen>(
                builder: (_) => const LoginScreen(),
              ),
            );
          } else if (state is IncidentShowSettingsState) {
            Navigator.of(context).pushReplacement<dynamic, SettingsScreen>(
              MaterialPageRoute<SettingsScreen>(
                builder: (_) => SettingsScreen(),
              ),
            );
          }
        },
        child: BlocBuilder<IncidentBloc, IncidentState>(
          builder: (BuildContext context, IncidentState state) {
            if (state is InitialIncidentState) {
              return const Text('Incident Screen');
            } else {
              throw StateError('unknown state: $state');
            }
          },
        ),
      ),
    );
  }
}
