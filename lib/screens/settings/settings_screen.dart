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
    final TextEditingController branchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (BuildContext context, SettingsState state) {
        if (state is SettingsTdData) {
          return Form(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        controller: branchController,
                        autocorrect: false,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.greenAccent, width: 5.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 5.0),
                          ),
                          hintText: 'Branch',
                        ),
                      ),
                    ),
                    Icon(Icons.search),
                  ],
                ),
                if (state.durations == null)
                  const SearchList()
                else
                  SearchList(
                    items: state.durations,
                    selectedItem: state.selectedDurationId,
                    onChangedCallBack: (String newValue) {
                      BlocProvider.of<SettingsBloc>(context)
                        ..add(SettingsDurationSelected(newValue));
                    },
                  ),
              ],
            ),
          );
        } else {
          return Text('State: $state');
        }
      }),
    );
  }
}

class SearchList extends StatelessWidget {
  const SearchList({
    this.items,
    this.selectedItem,
    this.onChangedCallBack,
  });

  final List<IncidentDuration> items;
  final String selectedItem;
  final ValueChanged<String> onChangedCallBack;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      isExpanded: true,
      value: selectedItem,
      disabledHint: const Text('Waiting for data'),
      hint: const Text('Duration'),
      icon: items == null
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(),
            )
          : const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: onChangedCallBack,
      items: items
          ?.map((IncidentDuration duration) => DropdownMenuItem<String>(
                value: duration.id,
                child: Text(duration.name),
              ))
          ?.toList(),
    );
  }
}
