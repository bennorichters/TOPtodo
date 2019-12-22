import 'package:flutter/material.dart';
import 'package:toptodo/utils/colors.dart';
import 'package:toptodo_data/toptodo_data.dart';

// class SearchField<T extends TdModel> extends StatelessWidget {
//   const SearchField({
//     @required this.value,
//     @required this.label,
//     @required this.search,
//     @required this.validationText,
//   });

//   final T value;
//   final String label;
//   final VoidCallback search;
//   final String validationText;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: <Widget>[
//         Expanded(
//           child: TextFormField(
//             controller: TextEditingController()..text = (value?.name) ?? '',
//             enabled: true,
//             decoration: InputDecoration(
//               labelText: label,
//             ),
//             validator: (String textValue) =>
//                 value == null ? validationText : null,
//           ),
//         ),
//         IconButton(
//           icon: const Icon(Icons.search),
//           onPressed: search,
//         ),
//       ],
//     );
//   }
// }

class SearchField<T extends TdModel> extends FormField<T> {
  SearchField({
    @required this.value,
    @required this.label,
    @required this.search,
    @required this.validationText,
  }) : super(
          validator: (T _) => value == null ? validationText : null,
          builder: (FormFieldState<T> state) {
            return Column(
              children: <Widget>[
                Row(
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
                if (state.hasError)
                  Text(
                    state.errorText,
                    style: TextStyle(color: vermillion),
                  )
                else
                  Container()
              ],
            );
          },
        ) {
    print('SearchField constructor: $value');
  }

  final T value;
  final String label;
  final VoidCallback search;
  final String validationText;
}
