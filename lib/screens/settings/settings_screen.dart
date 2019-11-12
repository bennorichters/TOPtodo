import 'package:flutter/material.dart';
import 'package:toptopdo/data/model/topdesk_elements.dart';
import 'package:toptopdo/screens/settings/bloc/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc.dart';
import 'branch_search/branch_search_delegate.dart';

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
        title: const Text('Settings'),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (BuildContext context, SettingsState state) {
        if (state is SettingsTdData) {
          print('SettingsScreenState.build state: $state');
          return Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text((state.branch?.name) ?? 'Choose a branch'),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      final Branch chosenBranch = await showSearch<Branch>(
                        context: context,
                        delegate: BranchSearchDelegate(),
                      );

                      print('Chose Branch: $chosenBranch');

                      BlocProvider.of<SettingsBloc>(context)
                        ..add(SettingsBranchSelected(chosenBranch));
                    },
                  ),
                ],
              ),
              if (state.durations == null)
                const SearchList()
              else
                SearchList(
                  items: state.durations,
                  selectedItem: state.duration,
                  onChangedCallBack: (IncidentDuration newValue) {
                    BlocProvider.of<SettingsBloc>(context)
                      ..add(SettingsDurationSelected(newValue));
                  },
                ),
            ],
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
  final IncidentDuration selectedItem;
  final ValueChanged<IncidentDuration> onChangedCallBack;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<IncidentDuration>(
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
          ?.map(
              (IncidentDuration duration) => DropdownMenuItem<IncidentDuration>(
                    value: duration,
                    child: Text(duration.name),
                  ))
          ?.toList(),
    );
  }
}
