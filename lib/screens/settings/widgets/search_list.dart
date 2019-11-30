
import 'package:flutter/material.dart';
import 'package:toptodo_data/toptodo_data.dart';

class SearchList<T extends TdModel> extends StatelessWidget {
  const SearchList({
    @required this.name,
    this.items,
    this.selectedItem,
    this.onChangedCallBack,
  });

  final String name;
  final Iterable<T> items;
  final T selectedItem;
  final ValueChanged<T> onChangedCallBack;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      isExpanded: true,
      value: selectedItem,
      disabledHint: const Text('Waiting for data'),
      hint: Text(name),
      icon: items == null
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(),
            )
          : const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: onChangedCallBack,
      items: items
          ?.map((T tdModel) => DropdownMenuItem<T>(
                value: tdModel,
                child: Text(tdModel.name),
              ))
          ?.toList(),
    );
  }
}
