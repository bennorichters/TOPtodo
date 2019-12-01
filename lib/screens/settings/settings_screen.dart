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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
          return Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: TextEditingController()
                            ..text = (state.branch?.name) ?? 'Choose a branch',
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: 'Branch',
                          ),
                          style: TextStyle(
                            color: (state.branch == null)
                                ? Colors.red
                                : Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _searchBranch(context),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: TextFormField(
                        controller: TextEditingController()
                          ..text = (state.person?.name) ??
                              (state.branch == null
                                  ? 'First choose a branch'
                                  : 'Choose a person'),
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'Person',
                        ),
                        style: TextStyle(
                          color: (state.person == null)
                              ? Colors.red
                              : Colors.black,
                        ),
                      )),
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
                  _SubCategoryWidget(state: state),
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
              ),
            ),
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

class _SubCategoryWidget extends StatelessWidget {
  const _SubCategoryWidget({this.state});
  final SettingsTdData state;

  @override
  Widget build(BuildContext context) {
    if (state.category == null) {
      return const Text('First choose a category');
    }

    return SearchList<SubCategory>(
      name: 'Sub category',
      items: state.subCategories,
      selectedItem: state.subCategory,
      onChangedCallBack: (SubCategory newValue) {
        BlocProvider.of<SettingsBloc>(context)
          ..add(SettingsSubCategorySelected(newValue));
      },
    );
  }
}
