import 'package:flutter/material.dart';
import 'package:toptodo_data/toptodo_data.dart';

class SearchField<T extends TdModel> extends StatelessWidget {
  const SearchField({
    @required this.value,
    @required this.label,
    @required this.search,
  });

  final T value;
  final String label;
  final VoidCallback search;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextFormField(
            controller: TextEditingController()..text = (value?.name) ?? '',
            enabled: false,
            decoration: InputDecoration(
              labelText: label,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: search,
        ),
      ],
    );
  }
}
