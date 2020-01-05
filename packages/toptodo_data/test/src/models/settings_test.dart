import 'dart:convert';

import 'package:test/test.dart';

import 'package:toptodo_data/toptodo_data.dart';

void main() {
  group('settings', () {
    test('isComplete', () {
      expect(Settings().isComplete(), isFalse);
      expect(Settings(branchId: 'a', callerId: 'a').isComplete(), isFalse);
      expect(
          Settings(
            branchId: 'a',
            callerId: 'a',
            categoryId: 'a',
            subCategoryId: 'a',
            incidentDurationId: 'a',
            incidentOperatorId: 'a',
          ).isComplete(),
          isTrue);
    });

    test('equals', () {
      final a = Settings(
        branchId: 'a',
        callerId: 'a',
        categoryId: 'a',
        subCategoryId: 'a',
        incidentDurationId: 'a',
        incidentOperatorId: 'a',
      );
      final b = Settings(
        branchId: 'a',
        callerId: 'a',
        categoryId: 'a',
        subCategoryId: 'a',
        incidentDurationId: 'a',
        incidentOperatorId: 'a',
      );
      final c = Settings(
        branchId: 'a',
        callerId: 'a',
        categoryId: 'a',
        subCategoryId: 'a',
        incidentDurationId: 'a',
        incidentOperatorId: 'c',
      );

      expect(a == b, isTrue);
      expect(a == c, isFalse);
    });

    test('fromJson', () {
      final jsonString = '''
      {
        "branchId": "a", 
        "callerId": "a", 
        "categoryId": "a", 
        "subCategoryId": "a", 
        "incidentDurationId": "a", 
        "incidentOperatorId": "a"
      }
      ''';

      final decoded = json.decode(jsonString);

      final a = Settings(
        branchId: 'a',
        callerId: 'a',
        categoryId: 'a',
        subCategoryId: 'a',
        incidentDurationId: 'a',
        incidentOperatorId: 'a',
      );

      expect(Settings.fromJson(decoded) == a, isTrue);
    });

    test('toString', () {
      expect(Settings().toString(),
          'Settings [${Settings().toJson().toString()}]');
    });
  });
}
