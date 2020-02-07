import 'package:test/test.dart';

import 'package:toptodo/blocs/td_model_search/bloc.dart';

void main() {
  group('td model search event', () {
    test('equals', () {
      expect(NewSearch() == NewSearch(), isTrue);

      expect(
        SearchFinishedQuery(
              linkedTo: null,
              query: 'testing',
            ) ==
            SearchFinishedQuery(
              linkedTo: null,
              query: 'testing',
            ),
        isTrue,
      );
    });

    test('toString', () {
      expect(
        SearchFinishedQuery(
          linkedTo: null,
          query: 'testing',
        ).toString().contains('testing'),
        isTrue,
      );
    });
  });
}
