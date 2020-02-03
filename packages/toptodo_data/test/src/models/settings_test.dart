import 'dart:convert';

import 'package:test/test.dart';

import 'package:toptodo_data/toptodo_data.dart';

void main() {
  group('settings', () {
    test('isComplete', () {
      expect(Settings().isComplete, isFalse);
      expect(Settings(tdBranchId: 'a', tdCallerId: 'a').isComplete, isFalse);
      expect(
          Settings(
            tdBranchId: 'a',
            tdCallerId: 'a',
            tdCategoryId: 'a',
            tdSubcategoryId: 'a',
            tdDurationId: 'a',
            tdOperatorId: 'a',
          ).isComplete,
          isTrue);
    });

    test('equals', () {
      final a = Settings(
        tdBranchId: 'a',
        tdCallerId: 'a',
        tdCategoryId: 'a',
        tdSubcategoryId: 'a',
        tdDurationId: 'a',
        tdOperatorId: 'a',
      );
      final b = Settings(
        tdBranchId: 'a',
        tdCallerId: 'a',
        tdCategoryId: 'a',
        tdSubcategoryId: 'a',
        tdDurationId: 'a',
        tdOperatorId: 'a',
      );
      final c = Settings(
        tdBranchId: 'a',
        tdCallerId: 'a',
        tdCategoryId: 'a',
        tdSubcategoryId: 'a',
        tdDurationId: 'a',
        tdOperatorId: 'c',
      );

      expect(a == b, isTrue);
      expect(a == c, isFalse);
    });

    test('fromJson', () {
      final jsonString = '''
      {
        "tdBranchId": "a", 
        "tdCallerId": "a", 
        "tdCategoryId": "a", 
        "tdSubcategoryId": "a", 
        "tdDurationId": "a", 
        "tdOperatorId": "a"
      }
      ''';

      final decoded = json.decode(jsonString);

      final a = Settings(
        tdBranchId: 'a',
        tdCallerId: 'a',
        tdCategoryId: 'a',
        tdSubcategoryId: 'a',
        tdDurationId: 'a',
        tdOperatorId: 'a',
      );

      expect(Settings.fromJson(decoded) == a, isTrue);
    });

    test('toString', () {
      expect(Settings().toString(),
          'Settings [${Settings().toJson().toString()}]');
    });
  });
}
