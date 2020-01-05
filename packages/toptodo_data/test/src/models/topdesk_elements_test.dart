import 'package:test/test.dart';

import 'package:toptodo_data/toptodo_data.dart';

void main() {
  group('topdesk elements', () {
    test('asserts', () {
      expect(() => Branch(id: null, name: 'a'), throwsA(isA<AssertionError>()));
      expect(() => Branch(id: 'a', name: null), throwsA(isA<AssertionError>()));
    });

    test('equals by id', () {
      expect(Branch(id: 'a', name: 'b') == Branch(id: 'a', name: 'c'), isTrue);
      expect(Branch(id: 'a', name: 'b') == Branch(id: 'b', name: 'b'), isFalse);
    });

    test('toString', () {
      expect(Branch(id: 'a', name: 'b').toString(), 'b');
    });

    test('branch', () {
      final b = Branch(id: 'a', name: 'b');
      expect(b.id, 'a');
      expect(b.name, 'b');
    });

    test('caller', () {
      final b = Branch(id: 'a', name: 'b');
      final c = Caller(id: 'a', name: 'b', avatar: 'av', branch: b);
      expect(c.id, 'a');
      expect(c.name, 'b');
      expect(c.avatar, 'av');
      expect(c.branch, b);
    });

    test('caller null avatar allowed', () {
      final b = Branch(id: 'a', name: 'b');
      final c = Caller(id: 'a', name: 'b', avatar: null, branch: b);
      expect(c.avatar, null);
    });

    test('caller null branch assertion error', () {
      expect(
        () => Caller(
          id: 'a',
          name: 'b',
          avatar: 'av',
          branch: null,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('category', () {
      final c = Category(id: 'a', name: 'b');
      expect(c.id, 'a');
      expect(c.name, 'b');
    });

    test('sub category', () {
      final c = Category(id: 'a', name: 'b');
      final s = SubCategory(id: 'a', name: 'b', category: c);
      expect(s.id, 'a');
      expect(s.name, 'b');
      expect(s.category, c);
    });

    test('sub category null category assertion error', () {
      expect(
        () => SubCategory(
          id: 'a',
          name: 'b',
          category: null,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('duration', () {
      final d = IncidentDuration(id: 'a', name: 'b');
      expect(d.id, 'a');
      expect(d.name, 'b');
    });

    test('operator', () {
      final op = IncidentOperator(
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
      final op = IncidentOperator(
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
        () => IncidentOperator(
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
        () => IncidentOperator(
          id: 'a',
          name: 'b',
          avatar: 'av',
          firstLine: true,
          secondLine: null,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
