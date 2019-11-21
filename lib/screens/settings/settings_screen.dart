import 'package:flutter/material.dart';
import 'package:toptodo/screens/settings/bloc/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptodo_data/toptodo_data.dart';

import 'bloc/bloc.dart';
import 'branch_search/td_model_search_delegate.dart';

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
                      final Branch chosenBranch = await showSearch<TdModel>(
                        context: context,
                        delegate: TdModelSearchDelegate.allBranches(),
                      );

                      BlocProvider.of<SettingsBloc>(context)
                        ..add(SettingsBranchSelected(chosenBranch));
                    },
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text((state.person?.name) ??
                        (state.branch == null
                            ? 'First choose a branch'
                            : 'Choose a person')),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: (state.branch == null) ? null : () async {},
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

  final Iterable<IncidentDuration> items;
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
