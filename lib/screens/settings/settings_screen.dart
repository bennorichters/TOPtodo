import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptodo/blocs/settings/bloc.dart';
import 'package:toptodo/screens/settings/widgets/search_list.dart';
import 'package:toptodo_data/toptodo_data.dart';

import 'widgets/td_model_search_delegate.dart';

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
              SearchList<Category>(
                name: 'Category',
                items: state.categories,
                selectedItem: state.category,
                onChangedCallBack: (Category newValue) {
                  BlocProvider.of<SettingsBloc>(context)
                    ..add(SettingsCategorySelected(newValue));
                },
              ),
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
