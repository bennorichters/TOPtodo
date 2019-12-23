import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptodo/blocs/incident/bloc.dart';
import 'package:toptodo/blocs/login/bloc.dart';
import 'package:toptodo/screens/login/login_screen.dart';
import 'package:toptodo/screens/settings/settings_screen.dart';
import 'package:toptodo_data/toptodo_data.dart';

typedef NavigateToScreen = Function(BuildContext context);

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
        actions: [
          PopupMenuButton<NavigateToScreen>(
            onSelected: (NavigateToScreen choice) {
              choice(context);
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<NavigateToScreen>(
                  child: const Text('settings'),
                  value: (BuildContext context) => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => SettingsScreen()),
                  ),
                ),
                PopupMenuItem<NavigateToScreen>(
                  child: const Text('log out'),
                  value: (BuildContext context) {
                    BlocProvider.of<LoginBloc>(context)
                      ..add(const AppStarted());

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                ),
              ];
            },
          ),
        ],
      ),
      body: BlocBuilder<IncidentBloc, IncidentState>(
        builder: (BuildContext context, IncidentState state) {
          if (state is IncidentState) {
            return const Text('Incident Screen');
          } else {
            throw StateError('unknown state: $state');
          }
        },
      ),
    );
  }
}
