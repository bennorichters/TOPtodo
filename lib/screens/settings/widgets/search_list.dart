import 'package:flutter/material.dart';
import 'package:toptodo_data/toptodo_data.dart';

class SearchList<T extends TdModel> extends StatelessWidget {
  const SearchList({
    @required this.name,
    @required this.validationText,
    this.items,
    this.selectedItem,
    this.onChangedCallBack,
  });

  final String name;
  final String validationText;
  final Iterable<T> items;
  final T selectedItem;
  final ValueChanged<T> onChangedCallBack;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        labelText: (items == null) ? '' : name,
      ),
      value: selectedItem,
      validator: (T _) => selectedItem == null ? validationText : null,
      onChanged: onChangedCallBack,
      hint: (items == null)
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(),
            )
          : Container(),
      items: items
          ?.map((T tdModel) => DropdownMenuItem<T>(
                value: tdModel,
                child: Text(tdModel.name),
              ))
          ?.toList(),
    );
  }
}
