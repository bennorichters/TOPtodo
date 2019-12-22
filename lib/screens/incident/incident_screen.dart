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
        title: const Text('Create todo'),
        actions: <Widget>[
          PopupMenuButton<IncidentEvent>(
            onSelected: (IncidentEvent event) {
              BlocProvider.of<IncidentBloc>(context)..add(event);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<IncidentEvent>>[
                PopupMenuItem<IncidentEvent>(
                  value: IncidentShowSettingsEvent(),
                  child: const Text('settings'),
                ),
                PopupMenuItem<IncidentEvent>(
                  value: IncidentLogOutEvent(),
                  child: const Text('log out'),
                ),
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
            if (state is IncidentState) {
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
