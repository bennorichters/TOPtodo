import 'package:test/test.dart';

import 'package:toptodo/blocs/settings/bloc.dart';
import 'package:toptodo_data/toptodo_data.dart';

void main() {
  group('settings event', () {
    final branchA = TdBranch(id: '1', name: 'branch A');
    final callerA = TdCaller(
      id: '1',
      name: 'caller A',
      avatar: 'img',
      branch: branchA,
    );

    test('equals', () {
      expect(
        ValueSelected(tdBranch: branchA) == ValueSelected(tdBranch: branchA),
        isTrue,
      );
      expect(
        ValueSelected(tdBranch: branchA) == ValueSelected(tdCaller: callerA),
        isFalse,
      );
    });
  });
}
