import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:toptodo/blocs/settings/bloc.dart';
import 'package:toptodo/constants/keys.dart' as ttd_keys;
import 'package:toptodo/screens/settings/widgets/search_list.dart';
import 'package:toptodo_data/toptodo_data.dart';

class SubcategorySearchList extends StatelessWidget {
  const SubcategorySearchList({@required this.formState});
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
      key: const Key(ttd_keys.subcategorySearchList),
      name: 'Subcategory',
      validationText: 'Choose a subcategory',
      items: formState.tdSubcategories,
      selectedItem: formState.tdSubcategory,
      onChangedCallBack: (TdSubcategory newValue) {
        BlocProvider.of<SettingsBloc>(context)
            .add(ValueSelected(tdSubcategory: newValue));
      },
    );
  }
}
