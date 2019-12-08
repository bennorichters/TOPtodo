import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    @required this.value,
    @required this.label,
    @required this.search,
  });

  final String value;
  final String label;
  final VoidCallback search;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextFormField(
            controller: TextEditingController()..text = value,
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
