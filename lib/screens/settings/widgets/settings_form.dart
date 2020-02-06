import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptodo/widgets/landscape_padding.dart';

import 'package:toptodo_data/toptodo_data.dart';

import 'package:toptodo/blocs/settings/bloc.dart';
import 'package:toptodo/blocs/td_model_search/bloc.dart';
import 'package:toptodo/screens/incident/incident_screen.dart';
import 'package:toptodo/screens/settings/widgets/search_field.dart';
import 'package:toptodo/screens/settings/widgets/search_list.dart';
import 'package:toptodo/screens/settings/widgets/td_model_search_delegate.dart';
import 'package:toptodo/utils/td_colors.dart';
import 'package:toptodo/widgets/td_button.dart';
import 'package:toptodo/widgets/td_shape.dart';

class SettingsForm extends StatelessWidget {
  const SettingsForm(this.state);
  final SettingsWithForm state;

  static final Widget _verticalSpace = const SizedBox(height: 10);
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return TdShapeBackground(
      longSide: LongSide.right,
      color: TdColors.duckEgg,
      child: LandscapePadding(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SearchField<TdBranch>(
                  value: state.formState.tdBranch,
                  label: 'Branch',
                  search: _searchBranch(context),
                  validationText: 'Choose a branch',
                ),
                SearchField<TdCaller>(
                  value: state.formState.tdCaller,
                  label: 'Caller' +
                      (state.formState.tdBranch == null
                          ? ' (first choose a branch)'
                          : ''),
                  search: _searchCaller(context, state.formState.tdBranch),
                  validationText: 'Choose a caller',
                ),
                SearchList<TdCategory>(
                  name: 'Category',
                  validationText: 'Choose a Category',
                  items: state.formState.tdCategories,
                  selectedItem: state.formState.tdCategory,
                  onChangedCallBack: (TdCategory newValue) {
                    BlocProvider.of<SettingsBloc>(context)
                      ..add(ValueSelected(tdCategory: newValue));
                  },
                ),
                _SubcategoryWidget(formState: state.formState),
                SearchList<TdDuration>(
                  name: 'Duration',
                  validationText: 'Choose a Duration',
                  items: state.formState.tdDurations,
                  selectedItem: state.formState.tdDuration,
                  onChangedCallBack: (TdDuration newValue) {
                    BlocProvider.of<SettingsBloc>(context)
                      ..add(ValueSelected(tdDuration: newValue));
                  },
                ),
                SearchField<TdOperator>(
                  label: 'Operator',
                  value: state.formState.tdOperator,
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
                        MaterialPageRoute(
                            builder: (context) => IncidentScreen()),
                      );
                    } else if (_formKey.currentState.validate()) {
                      BlocProvider.of<SettingsBloc>(context)
                        ..add(SettingsSave());
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  VoidCallback _searchBranch(BuildContext context) {
    return () async {
      _initNewSearch(context);
      final chosenBranch = await showSearch<TdBranch>(
        context: context,
        delegate: TdModelSearchDelegate<TdBranch>.allBranches(),
      );

      BlocProvider.of<SettingsBloc>(context)
        ..add(ValueSelected(tdBranch: chosenBranch));
    };
  }

  VoidCallback _searchCaller(BuildContext context, TdBranch branch) {
    return (branch == null)
        ? null
        : () async {
            _initNewSearch(context);
            final chosenCaller = await showSearch<TdCaller>(
              context: context,
              delegate: TdModelSearchDelegate<TdCaller>.callersForBranch(
                branch: branch,
              ),
            );

            BlocProvider.of<SettingsBloc>(context)
              ..add(ValueSelected(tdCaller: chosenCaller));
          };
  }

  VoidCallback _searchOperator(BuildContext context) {
    return () async {
      _initNewSearch(context);
      final chosenOperator = await showSearch<TdOperator>(
        context: context,
        delegate: TdModelSearchDelegate<TdOperator>.allOperators(),
      );

      BlocProvider.of<SettingsBloc>(context)
        ..add(ValueSelected(tdOperator: chosenOperator));
    };
  }

  void _initNewSearch(BuildContext context) {
    BlocProvider.of<TdModelSearchBloc>(context)..add(TdModelNewSearch());
  }
}

class _SubcategoryWidget extends StatelessWidget {
  const _SubcategoryWidget({this.formState});
  final SettingsFormState formState;

  @override
  Widget build(BuildContext context) {
    if (formState.tdCategory == null) {
      return TextFormField(
        enabled: false,
        decoration: const InputDecoration(
          labelText: 'Subcategory (first choose a category)',
        ),
      );
    }

    return SearchList<TdSubcategory>(
      name: 'Subcategory',
      validationText: 'Choose a subcategory',
      items: formState.tdSubcategories,
      selectedItem: formState.tdSubcategory,
      onChangedCallBack: (TdSubcategory newValue) {
        BlocProvider.of<SettingsBloc>(context)
          ..add(ValueSelected(tdSubcategory: newValue));
      },
    );
  }
}
