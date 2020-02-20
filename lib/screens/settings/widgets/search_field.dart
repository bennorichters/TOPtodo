import 'package:flutter/material.dart';
import 'package:toptodo/constants/keys.dart' as ttd_keys;

import 'package:toptodo_data/toptodo_data.dart';

class SearchField<T extends TdModel> extends FormField<T> {
  SearchField({
    @required this.value,
    @required this.label,
    @required this.search,
    @required this.validationText,
    Key key,
  }) : super(
          key: key,
          validator: (T _) => value == null ? validationText : null,
          builder: (FormFieldState<T> state) {
            return InputDecorator(
              child: GestureDetector(
                onTap: search,
                child: Row(
                  key: Key(ttd_keys.searchFieldRow),
                  children: [
                    Expanded(
                      child: Text((value?.name) ?? ''),
                    ),
                    const Icon(Icons.search),
                  ],
                ),
              ),
              isEmpty: value == null,
              decoration: InputDecoration(
                labelText: label,
                errorText: state.errorText,
              ),
            );
          },
        );

  final T value;
  final String label;
  final VoidCallback search;
  final String validationText;
}
