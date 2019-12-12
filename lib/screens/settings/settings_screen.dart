import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptodo/blocs/login/bloc.dart';
import 'package:toptodo/blocs/settings/bloc.dart';
import 'package:toptodo/screens/settings/widgets/search_field.dart';
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
  final Widget _verticalSpace = const SizedBox(height: 10);

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
            BlocProvider.of<LoginBloc>(context)..add(const AppStarted());

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
            final SettingsFormState formState = state.formState;
            return Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    SearchField<Branch>(
                      value: formState.branch,
                      label: 'Branch',
                      search: _searchBranch(context),
                    ),
                    SearchField<Caller>(
                      value: formState.caller,
                      label: 'Caller' +
                          (formState.branch == null
                              ? ' (first choose a branch)'
                              : ''),
                      search: _searchCaller(context, formState.branch),
                    ),
                    SearchList<Category>(
                      name: 'Category',
                      items: formState.categories,
                      selectedItem: formState.category,
                      onChangedCallBack: (Category newValue) {
                        BlocProvider.of<SettingsBloc>(context)
                          ..add(SettingsCategorySelected(newValue));
                      },
                    ),
                    _SubCategoryWidget(state: state),
                    SearchList<IncidentDuration>(
                      name: 'Duration',
                      items: formState.durations,
                      selectedItem: formState.duration,
                      onChangedCallBack: (IncidentDuration newValue) {
                        BlocProvider.of<SettingsBloc>(context)
                          ..add(SettingsDurationSelected(newValue));
                      },
                    ),
                    SearchField<IncidentOperator>(
                      label: 'Operator',
                      value: formState.incidentOperator,
                      search: _searchOperator(context),
                    ),
                    _verticalSpace,
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
      final Branch chosenBranch = await showSearch<Branch>(
        context: context,
        delegate: TdModelSearchDelegate<Branch>.allBranches(),
      );

      BlocProvider.of<SettingsBloc>(context)
        ..add(SettingsBranchSelected(chosenBranch));
    };
  }

  VoidCallback _searchCaller(BuildContext context, Branch branch) {
    return (branch == null)
        ? null
        : () async {
            final Caller chosenCaller = await showSearch<Caller>(
              context: context,
              delegate: TdModelSearchDelegate<Caller>.callersForBranch(
                branch: branch,
              ),
            );

            BlocProvider.of<SettingsBloc>(context)
              ..add(SettingsCallerSelected(chosenCaller));
          };
  }

  VoidCallback _searchOperator(BuildContext context) {
    return () async {
      final IncidentOperator chosenOperator =
          await showSearch<IncidentOperator>(
        context: context,
        delegate: TdModelSearchDelegate<IncidentOperator>.allOperators(),
      );

      BlocProvider.of<SettingsBloc>(context)
        ..add(SettingsOperatorSelected(chosenOperator));
    };
  }
}

class _SubCategoryWidget extends StatelessWidget {
  const _SubCategoryWidget({this.state});
  final SettingsTdData state;

  @override
  Widget build(BuildContext context) {
    final SettingsFormState formState = state.formState;
    if (formState.category == null) {
      return TextFormField(
        enabled: false,
        decoration: InputDecoration(
          labelText: 'Sub category (first choose a category)',
        ),
      );
    }

    return SearchList<SubCategory>(
      name: 'Sub category',
      items: formState.subCategories,
      selectedItem: formState.subCategory,
      onChangedCallBack: (SubCategory newValue) {
        BlocProvider.of<SettingsBloc>(context)
          ..add(SettingsSubCategorySelected(newValue));
      },
    );
  }
}
