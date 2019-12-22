import 'package:flutter/material.dart';
import 'package:toptodo_data/toptodo_data.dart';

class SearchField<T extends TdModel> extends FormField<T> {
  SearchField({
    @required this.value,
    @required this.label,
    @required this.search,
    @required this.validationText,
  }) : super(
          validator: (T _) => value == null ? validationText : null,
          builder: (FormFieldState<T> state) {
            return InputDecorator(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text((value?.name) ?? ''),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: search,
                  ),
                ],
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
