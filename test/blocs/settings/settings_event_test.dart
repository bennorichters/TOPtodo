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
        SettingsBranchSelected(branchA) == SettingsBranchSelected(branchA),
        isTrue,
      );
      expect(
        SettingsCallerSelected(callerA) == SettingsCallerSelected(callerA),
        isTrue,
      );
      expect(
        SettingsCategorySelected(categoryA) ==
            SettingsCategorySelected(categoryA),
        isTrue,
      );
      expect(
        SettingsSubcategorySelected(subcategoryA) ==
            SettingsSubcategorySelected(subcategoryA),
        isTrue,
      );
      expect(
        SettingsDurationSelected(durationA) ==
            SettingsDurationSelected(durationA),
        isTrue,
      );
      expect(
        SettingsOperatorSelected(operatorA) ==
            SettingsOperatorSelected(operatorA),
        isTrue,
      );
    });
  });
}
