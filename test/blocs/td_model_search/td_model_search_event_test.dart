import 'package:test/test.dart';

import 'package:toptodo/blocs/td_model_search/bloc.dart';

void main() {
  group('td model search event', () {
    test('equals', () {
      expect(TdModelNewSearch() == TdModelNewSearch(), isTrue);

      expect(
        TdModelSearchFinishedQuery(
              linkedTo: null,
              query: 'testing',
            ) ==
            TdModelSearchFinishedQuery(
              linkedTo: null,
              query: 'testing',
            ),
        isTrue,
      );
    });

    test('toString', () {
      expect(
        TdModelSearchFinishedQuery(
          linkedTo: null,
          query: 'testing',
        ).toString().contains('testing'),
        isTrue,
      );
    });
  });
}
