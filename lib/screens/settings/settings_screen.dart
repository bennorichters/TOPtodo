import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptodo/blocs/settings/bloc.dart';
import 'package:toptodo/screens/settings/widgets/search_list.dart';
import 'package:toptodo/widgets/td_button.dart';
import 'package:toptodo_data/toptodo_data.dart';

import '../login/login_screen.dart';
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
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (_) {
              BlocProvider.of<SettingsBloc>(context)
                ..add(SettingsUserLoggedOut());
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: '1',
                  child: const Text('log out'),
                )
              ];
            },
          ),
        ],
      ),
      body: BlocListener<SettingsBloc, SettingsState>(
        listener: (BuildContext context, SettingsState state) {
          if (state is SettingsLogout) {
            Navigator.of(context).pushReplacement<dynamic, LoginScreen>(
              MaterialPageRoute<LoginScreen>(
                builder: (_) => const LoginScreen(),
              ),
            );
          }
        },
        child: BlocBuilder<SettingsBloc, SettingsState>(
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
                              ..text = (state.branch?.name) ?? '',
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: 'Branch',
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
                              ..text = (state.person?.name) ?? '',
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: 'Person' +
                                  (state.branch == null
                                      ? ' (first choose a branch)'
                                      : ''),
                            ),
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
                    SearchList<IncidentDuration>(
                      name: 'Operator',
                      items: state.durations,
                      selectedItem: state.duration,
                      onChangedCallBack: (IncidentDuration newValue) {
                        BlocProvider.of<SettingsBloc>(context)
                          ..add(SettingsDurationSelected(newValue));
                      },
                    ),
                    TdButton(
                      text: 'save',
                      onTap: () {
                        BlocProvider.of<SettingsBloc>(context)
                          ..add(SettingsSave());
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        }),
      ),
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
      return TextFormField(
        enabled: false,
        decoration: InputDecoration(
          labelText: 'Sub category (first choose a category)',
        ),
      );
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
