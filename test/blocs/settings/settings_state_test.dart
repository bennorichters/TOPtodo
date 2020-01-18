import 'package:test/test.dart';

import 'package:toptodo/blocs/settings/bloc.dart';
import 'package:toptodo_data/toptodo_data.dart';

void main() {
  group('settings state', () {
    test('toString', () {
      final operatorA = TdOperator(
        id: '1',
        name: 'operator A',
        avatar: 'img',
        firstLine: true,
        secondLine: true,
      );
      expect(
        SettingsLoading(
          currentOperator: operatorA,
        ).toString().contains('operator A'),
        isTrue,
      );
      expect(
        SettingsTdData(
          currentOperator: operatorA,
          formState: null,
        ).toString().contains('formState'),
        isTrue,
      );
    });
  });
}
