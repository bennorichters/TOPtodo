import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptodo/screens/settings/widgets/subcategory_search_list.dart';
import 'package:toptodo/widgets/landscape_padding.dart';

import 'package:toptodo_data/toptodo_data.dart';

import 'package:toptodo/blocs/settings/bloc.dart';
import 'package:toptodo/blocs/td_model_search/bloc.dart';
import 'package:toptodo/constants/colors.dart' as ttd_colors;
import 'package:toptodo/constants/keys.dart' as ttd_keys;
import 'package:toptodo/screens/incident/incident_screen.dart';
import 'package:toptodo/screens/settings/widgets/search_field.dart';
import 'package:toptodo/screens/settings/widgets/search_list.dart';
import 'package:toptodo/screens/settings/widgets/td_model_search_delegate.dart';
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
      color: ttd_colors.duckEgg,
      child: LandscapePadding(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SearchField<TdBranch>(
                  key: Key(ttd_keys.settingsFormSearchFieldBranch),
                  value: state.formState.tdBranch,
                  label: 'Branch',
                  search: _searchBranch(context),
                  validationText: 'Choose a branch',
                ),
                SearchField<TdCaller>(
                  key: Key(ttd_keys.settingsFormSearchFieldCaller),
                  value: state.formState.tdCaller,
                  label: 'Caller' +
                      (state.formState.tdBranch == null
                          ? ' (first choose a branch)'
                          : ''),
                  search: _searchCaller(context, state.formState.tdBranch),
                  validationText: 'Choose a caller',
                ),
                SearchList<TdCategory>(
                  key: Key(ttd_keys.settingsFormSearchFieldCategory),
                  name: 'Category',
                  validationText: 'Choose a Category',
                  items: state.formState.tdCategories,
                  selectedItem: state.formState.tdCategory,
                  onChangedCallBack: (TdCategory newValue) {
                    BlocProvider.of<SettingsBloc>(context)
                        .add(ValueSelected(tdCategory: newValue));
                  },
                ),
                SubcategorySearchList(formState: state.formState),
                SearchList<TdDuration>(
                  key: Key(ttd_keys.settingsFormSearchFieldDuration),
                  name: 'Duration',
                  validationText: 'Choose a Duration',
                  items: state.formState.tdDurations,
                  selectedItem: state.formState.tdDuration,
                  onChangedCallBack: (TdDuration newValue) {
                    BlocProvider.of<SettingsBloc>(context)
                        .add(ValueSelected(tdDuration: newValue));
                  },
                ),
                SearchField<TdOperator>(
                  key: Key(ttd_keys.settingsFormSearchFieldOperator),
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
                          .add(SettingsSave());
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
          .add(ValueSelected(tdBranch: chosenBranch));
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
                .add(ValueSelected(tdCaller: chosenCaller));
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
          .add(ValueSelected(tdOperator: chosenOperator));
    };
  }

  void _initNewSearch(BuildContext context) {
    BlocProvider.of<TdModelSearchBloc>(context).add(NewSearch());
  }
}
