import 'package:test/test.dart';

import 'package:toptodo_data/toptodo_data.dart';

void main() {
  group('topdesk elements', () {
    test('asserts', () {
      expect(
          () => TdBranch(id: null, name: 'a'), throwsA(isA<AssertionError>()));
      expect(
          () => TdBranch(id: 'a', name: null), throwsA(isA<AssertionError>()));
    });

    test('equals by id', () {
      expect(
          TdBranch(id: 'a', name: 'b') == TdBranch(id: 'a', name: 'c'), isTrue);
      expect(TdBranch(id: 'a', name: 'b') == TdBranch(id: 'b', name: 'b'),
          isFalse);
    });

    test('toString', () {
      expect(TdBranch(id: 'a', name: 'b').toString(), 'b');
    });

    test('branch', () {
      final b = TdBranch(id: 'a', name: 'b');
      expect(b.id, 'a');
      expect(b.name, 'b');
    });

    test('caller', () {
      final b = TdBranch(id: 'a', name: 'b');
      final c = TdCaller(id: 'a', name: 'b', avatar: 'av', branch: b);
      expect(c.id, 'a');
      expect(c.name, 'b');
      expect(c.avatar, 'av');
      expect(c.branch, b);
    });

    test('caller null avatar allowed', () {
      final b = TdBranch(id: 'a', name: 'b');
      final c = TdCaller(id: 'a', name: 'b', avatar: null, branch: b);
      expect(c.avatar, null);
    });

    test('caller null branch assertion error', () {
      expect(
        () => TdCaller(
          id: 'a',
          name: 'b',
          avatar: 'av',
          branch: null,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('category', () {
      final c = TdCategory(id: 'a', name: 'b');
      expect(c.id, 'a');
      expect(c.name, 'b');
    });

    test('sub category', () {
      final c = TdCategory(id: 'a', name: 'b');
      final s = TdSubcategory(id: 'a', name: 'b', category: c);
      expect(s.id, 'a');
      expect(s.name, 'b');
      expect(s.category, c);
    });

    test('sub category null category assertion error', () {
      expect(
        () => TdSubcategory(
          id: 'a',
          name: 'b',
          category: null,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('duration', () {
      final d = TdDuration(id: 'a', name: 'b');
      expect(d.id, 'a');
      expect(d.name, 'b');
    });

    test('operator', () {
      final op = TdOperator(
        id: 'a',
        name: 'b',
        avatar: 'av',
        firstLine: true,
        secondLine: true,
      );
      expect(op.id, 'a');
      expect(op.name, 'b');
      expect(op.avatar, 'av');
      expect(op.firstLine, true);
      expect(op.secondLine, true);
    });

    test('operator null avatar allowed', () {
      final op = TdOperator(
        id: 'a',
        name: 'b',
        avatar: null,
        firstLine: true,
        secondLine: true,
      );
      expect(op.avatar, null);
    });

    test('operator null firstLine assertion error', () {
      expect(
        () => TdOperator(
          id: 'a',
          name: 'b',
          avatar: 'av',
          firstLine: null,
          secondLine: true,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('operator null secondLine assertion error', () {
      expect(
        () => TdOperator(
          id: 'a',
          name: 'b',
          avatar: 'av',
          firstLine: true,
          secondLine: null,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    group('fromJson', () {
      test('branch', () {
        final b = TdBranch.fromJson({'id': 'a', 'name': 'b'});
        expect(b.id, 'a');
        expect(b.name, 'b');
      });

      test('caller', () {
        final caller = TdCaller.fromJson({
          'id': 'a',
          'name': 'b',
          'avatar': null,
          'branch': {'id': 'a', 'name': 'b'},
        });
        expect(caller.id, 'a');
        expect(caller.name, 'b');
        expect(caller.avatar, null);
        expect(caller.branch.id, 'a');
        expect(caller.branch.name, 'b');
      });

      test('category', () {
        final cat = TdCategory.fromJson({'id': 'a', 'name': 'b'});
        expect(cat.id, 'a');
        expect(cat.name, 'b');
      });

      test('subcategory', () {
        final subcat = TdSubcategory.fromJson({
          'id': 'a',
          'name': 'b',
          'category': {'id': 'a', 'name': 'b'}
        });
        expect(subcat.id, 'a');
        expect(subcat.name, 'b');
        expect(subcat.category.id, 'a');
        expect(subcat.category.name, 'b');
      });

      test('duration', () {
        final duration = TdDuration.fromJson({'id': 'a', 'name': 'b'});
        expect(duration.id, 'a');
        expect(duration.name, 'b');
      });

      test('operator', () {
        final op = TdOperator.fromJson({
          'id': 'a',
          'name': 'b',
          'avatar': null,
          'firstLineCallOperator': true,
          'secondLineCallOperator': false,
        });
        expect(op.id, 'a');
        expect(op.name, 'b');
        expect(op.avatar, null);
        expect(op.firstLine, true);
        expect(op.secondLine, false);
      });
    });

    group('fromJson errors', () {
      test('branch without all required fields', () {
        expect(() => TdBranch.fromJson({}), throwsA(isA<AssertionError>()));
        expect(
            () => TdBranch.fromJson({
                  'id': 'a',
                }),
            throwsA(isA<AssertionError>()));
        expect(
            () => TdBranch.fromJson({
                  'name': 'a',
                }),
            throwsA(isA<AssertionError>()));
      });

      test('caller without branch', () {
        expect(
            () => TdCaller.fromJson({
                  'id': 'a',
                  'name': 'b',
                  'avatar': null,
                }),
            throwsA(isA<Error>()));
      });

      test('subcategory without category', () {
        expect(
            () => TdSubcategory.fromJson({
                  'id': 'a',
                  'name': 'b',
                }),
            throwsA(isA<Error>()));
      });

      test('operator without first or second line', () {
        expect(
            () => TdOperator.fromJson({
                  'id': 'a',
                  'name': 'b',
                  'avatar': null,
                  'firstLineCallOperator': true,
                }),
            throwsA(isA<Error>()));

        expect(
            () => TdOperator.fromJson({
                  'id': 'a',
                  'name': 'b',
                  'avatar': null,
                  'secondLineCallOperator': true,
                }),
            throwsA(isA<Error>()));

        expect(
            () => TdOperator.fromJson({
                  'id': 'a',
                  'name': 'b',
                  'avatar': null,
                  'firstLineCallOperator': null,
                  'secondLineCallOperator': true,
                }),
            throwsA(isA<Error>()));

        expect(
            () => TdOperator.fromJson({
                  'id': 'a',
                  'name': 'b',
                  'avatar': null,
                  'firstLineCallOperator': true,
                  'secondLineCallOperator': 'no boolean',
                }),
            throwsA(isA<Error>()));
      });
    });

    group('toJson', () {
      test('branch', () {
        final b = TdBranch(id: 'a', name: 'b');
        expect(TdBranch.fromJson(b.toJson()).id, 'a');
        expect(TdBranch.fromJson(b.toJson()).name, 'b');
      });

      test('caller', () {
        final b = TdBranch(id: 'a', name: 'b');
        final c = TdCaller(id: 'ca', name: 'cb', avatar: 'img', branch: b);
        expect(TdCaller.fromJson(c.toJson()).id, 'ca');
        expect(TdCaller.fromJson(c.toJson()).name, 'cb');
        expect(TdCaller.fromJson(c.toJson()).avatar, 'img');
        expect(TdCaller.fromJson(c.toJson()).branch.id, 'a');
        expect(TdCaller.fromJson(c.toJson()).branch.name, 'b');
      });

      test('subcategory', () {
        final c = TdCategory(id: 'a', name: 'b');
        final s = TdSubcategory(id: 'sa', name: 'sb', category: c);
        expect(TdSubcategory.fromJson(s.toJson()).id, 'sa');
        expect(TdSubcategory.fromJson(s.toJson()).name, 'sb');
        expect(TdSubcategory.fromJson(s.toJson()).category.id, 'a');
        expect(TdSubcategory.fromJson(s.toJson()).category.name, 'b');
      });
    });
    
    test('operator', () {
      final op = TdOperator(
        id: 'a',
        name: 'b',
        avatar: 'img',
        firstLine: false,
        secondLine: true,
      );
      expect(TdOperator.fromJson(op.toJson()).id, 'a');
      expect(TdOperator.fromJson(op.toJson()).name, 'b');
      expect(TdOperator.fromJson(op.toJson()).avatar, 'img');
      expect(TdOperator.fromJson(op.toJson()).firstLine, false);
      expect(TdOperator.fromJson(op.toJson()).secondLine, true);
    });
  });
}
