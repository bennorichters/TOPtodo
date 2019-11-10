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
          return _buildDurationDropDown();
        } else if (state is SettingsRetrievedDurations) {
          return _buildDurationDropDown(
            items: state.durations,
            selectedItem: state.selectedDurationId,
            onChangedCallBack: (String newValue) {
              BlocProvider.of<SettingsBloc>(context)
                ..add(SettingsDurationSelected(newValue));
            },
          );
        } else {
          return Text('State: $state');
        }
      }),
    );
  }

  static DropdownButton<String> _buildDurationDropDown({
    List<IncidentDuration> items,
    String selectedItem,
    ValueChanged<String> onChangedCallBack,
  }) {
    return DropdownButton<String>(
      isExpanded: true,
      value: selectedItem,
      disabledHint: Text('Waiting for data'),
      hint: Text('Duration'),
      icon: items == null
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(),
            )
          : Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: onChangedCallBack,
      items: items?.map((duration) => DropdownMenuItem<String>(
                value: duration.id,
                child: Text(duration.name),
              ))
          ?.toList(),
    );
  }
}
