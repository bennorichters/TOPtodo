import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptodo/blocs/settings/bloc.dart';
import 'package:toptodo/blocs/td_model_search/bloc.dart';
import 'package:toptodo/screens/incident/incident_screen.dart';
import 'package:toptodo/screens/settings/widgets/search_field.dart';
import 'package:toptodo/screens/settings/widgets/search_list.dart';
import 'package:toptodo/widgets/menu_operator_button.dart';
import 'package:toptodo/widgets/td_button.dart';
import 'package:toptodo_data/toptodo_data.dart';

import 'widgets/td_model_search_delegate.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key key}) : super(key: key);

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
    return BlocListener<SettingsBloc, SettingsState>(
      listener: (BuildContext context, SettingsState state) {
        if (state is SettingsSaved) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => IncidentScreen()),
          );
        }
      },
      child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (BuildContext context, SettingsState state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
            actions: [
              if (state is SettingsWithOperator)
                MenuOperatorButton(
                  state.currentOperator,
                  showSettings: false,
                ),
            ],
          ),
          body: (state is SettingsWithFormState)
              ? _SettingsForm(state)
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        );
      }),
    );
  }
}

class _SettingsForm extends StatelessWidget {
  _SettingsForm(this.state);
  final SettingsWithFormState state;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Widget _verticalSpace = const SizedBox(height: 10);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            SearchField<Branch>(
              value: state.formState.branch,
              label: 'Branch',
              search: _searchBranch(context),
              validationText: 'Choose a branch',
            ),
            SearchField<Caller>(
              value: state.formState.caller,
              label: 'Caller' +
                  (state.formState.branch == null
                      ? ' (first choose a branch)'
                      : ''),
              search: _searchCaller(context, state.formState.branch),
              validationText: 'Choose a caller',
            ),
            SearchList<Category>(
              name: 'Category',
              validationText: 'Choose a Category',
              items: state.formState.categories,
              selectedItem: state.formState.category,
              onChangedCallBack: (Category newValue) {
                BlocProvider.of<SettingsBloc>(context)
                  ..add(SettingsCategorySelected(newValue));
              },
            ),
            _SubCategoryWidget(formState: state.formState),
            SearchList<IncidentDuration>(
              name: 'Duration',
              validationText: 'Choose a Duration',
              items: state.formState.incidentDurations,
              selectedItem: state.formState.incidentDuration,
              onChangedCallBack: (IncidentDuration newValue) {
                BlocProvider.of<SettingsBloc>(context)
                  ..add(SettingsDurationSelected(newValue));
              },
            ),
            SearchField<IncidentOperator>(
              label: 'Operator',
              value: state.formState.incidentOperator,
              search: _searchOperator(context),
              validationText: 'Choose an operator',
            ),
            _verticalSpace,
            TdButton(
              text: 'save',
              onTap: () {
                if (state is SettingsSaved) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => IncidentScreen()),
                  );
                } else if (_formKey.currentState.validate()) {
                  BlocProvider.of<SettingsBloc>(context)..add(SettingsSave());
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  VoidCallback _searchBranch(BuildContext context) {
    return () async {
      _initNewSearch(context);
      final chosenBranch = await showSearch<Branch>(
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
            _initNewSearch(context);
            final chosenCaller = await showSearch<Caller>(
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
      _initNewSearch(context);
      final chosenOperator = await showSearch<IncidentOperator>(
        context: context,
        delegate: TdModelSearchDelegate<IncidentOperator>.allOperators(),
      );

      BlocProvider.of<SettingsBloc>(context)
        ..add(SettingsOperatorSelected(chosenOperator));
    };
  }

  void _initNewSearch(BuildContext context) {
    BlocProvider.of<TdModelSearchBloc>(context)..add(TdModelNewSearch());
  }
}

class _SubCategoryWidget extends StatelessWidget {
  const _SubCategoryWidget({this.formState});
  final SettingsFormState formState;

  @override
  Widget build(BuildContext context) {
    if (formState.category == null) {
      return TextFormField(
        enabled: false,
        decoration: const InputDecoration(
          labelText: 'Sub category (first choose a category)',
        ),
      );
    }

    return SearchList<SubCategory>(
      name: 'Sub category',
      validationText: 'Choose a sub category',
      items: formState.subCategories,
      selectedItem: formState.subCategory,
      onChangedCallBack: (SubCategory newValue) {
        BlocProvider.of<SettingsBloc>(context)
          ..add(SettingsSubCategorySelected(newValue));
      },
    );
  }
}
