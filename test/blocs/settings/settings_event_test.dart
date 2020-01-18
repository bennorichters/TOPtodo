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
    final categoryA = TdCategory(id: '1', name: 'category A');
    final subcategoryA = TdSubcategory(
      id: '11',
      name: 'subcategory A',
      category: categoryA,
    );
    final durationA = TdDuration(id: '1', name: 'duration A');
    final operatorA = TdOperator(
      id: '1',
      name: 'operator A',
      avatar: 'img',
      firstLine: true,
      secondLine: true,
    );

    test('equals', () {
      expect(
        BranchSelected(branchA) == BranchSelected(branchA),
        isTrue,
      );
      expect(
        CallerSelected(callerA) == CallerSelected(callerA),
        isTrue,
      );
      expect(
        CategorySelected(categoryA) == CategorySelected(categoryA),
        isTrue,
      );
      expect(
        SubcategorySelected(subcategoryA) == SubcategorySelected(subcategoryA),
        isTrue,
      );
      expect(
        DurationSelected(durationA) == DurationSelected(durationA),
        isTrue,
      );
      expect(
        OperatorSelected(operatorA) == OperatorSelected(operatorA),
        isTrue,
      );
    });
  });
}
