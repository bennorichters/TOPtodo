import 'package:flutter/material.dart';
import 'package:toptodo/screens/settings/bloc/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptodo_data/toptodo_data.dart';

import 'bloc/bloc.dart';
import 'td_model_search/td_model_search_delegate.dart';

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
                    icon: const Icon(Icons.search),
                    onPressed: _searchBranch(context),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      (state.person?.name) ??
                          (state.branch == null
                              ? 'First choose a branch'
                              : 'Choose a person'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _searchPerson(context, state.branch),
                  ),
                ],
              ),
              if (state.durations == null)
                const SearchList<IncidentDuration>(
                  name: 'Duration',
                )
              else
                SearchList<IncidentDuration>(
                  name: 'Duration',
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

  VoidCallback _searchBranch(BuildContext context) {
    return () async {
      final Branch chosenBranch = await showSearch<TdModel>(
        context: context,
        delegate: TdModelSearchDelegate.allBranches(),
      );

      BlocProvider.of<SettingsBloc>(context)
        ..add(SettingsBranchSelected(chosenBranch));
    };
  }

  VoidCallback _searchPerson(BuildContext context, Branch branch) {
    return (branch == null)
        ? null
        : () async {
            final Person chosenPerson = await showSearch<TdModel>(
              context: context,
              delegate: TdModelSearchDelegate.personsForBranch(
                branch: branch,
              ),
            );

            BlocProvider.of<SettingsBloc>(context)
              ..add(SettingsPersonSelected(chosenPerson));
          };
  }
}

class SearchList<T extends TdModel> extends StatelessWidget {
  const SearchList({
    @required this.name,
    this.items,
    this.selectedItem,
    this.onChangedCallBack,
  });

  final String name;
  final Iterable<T> items;
  final T selectedItem;
  final ValueChanged<T> onChangedCallBack;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      isExpanded: true,
      value: selectedItem,
      disabledHint: const Text('Waiting for data'),
      hint: Text(name),
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
          ?.map((T tdModel) => DropdownMenuItem<T>(
                value: tdModel,
                child: Text(tdModel.name),
              ))
          ?.toList(),
    );
  }
}
