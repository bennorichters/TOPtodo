import 'package:test/test.dart';

import 'package:toptodo/blocs/td_model_search/bloc.dart';
import 'package:toptodo_data/toptodo_data.dart';

void main() {
  group('td model search state', () {
    test('toString', () {
      final branchA = TdBranch(id: 'a', name: 'Branch A');
      expect(
        TdModelSearchResults<TdBranch>([branchA])
            .toString()
            .contains(branchA.toString()),
        isTrue,
      );
    });
  });
}
