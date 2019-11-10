import 'package:flutter/material.dart';
import 'package:toptopdo/data/model/topdesk_elements.dart';
import 'package:toptopdo/screens/settings/bloc/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/settings_bloc.dart';
import 'bloc/settings_event.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SettingsBloc>(context)..add(SettingsInit());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
        if (state is SettingsNoSearchListData) {
          return CircularProgressIndicator();
        } else if (state is SettingsRetrievedDurations) {
          return DropdownButton<String>(
            value: state.selectedDurationId,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String newValue) {
              BlocProvider.of<SettingsBloc>(context)
                ..add(SettingsDurationSelected(newValue));
            },
            items: state.durations
                .map((d) => DropdownMenuItem<String>(
                      value: d.id,
                      child: Text(d.name),
                    ))
                .toList(),
          );
        } else {
          return Text('State: $state');
        }
      }),
    );
  }
}
