import 'package:test/test.dart';
import 'package:toptodo_data/toptodo_data.dart';
import 'package:toptodo_topdesk_provider_mock/'
    'toptodo_topdesk_provider_mock.dart';

void main() {
  final ftp = FakeTopdeskProvider(
    latency: Duration(microseconds: 0),
  );

  group('special', () {
    test('init does nothing', () {
      ftp.init(null);
      ftp.init(null);
    });

    test('dispose does nothing', () {
      ftp.dispose();
    });
  });

  group('branch', () {
    test('find some', () async {
      final ds = await ftp.tdBranches(startsWith: 'E');
      expect(ds.length, 3);
    });

    test('by id find one', () async {
      final ba = await ftp.tdBranch(id: 'a');

      expect(ba.id, 'a');
    });

    test('by non-existent id throws', () async {
      expect(
        ftp.tdBranch(id: 'doesnotexist'),
        throwsA(
          TypeMatcher<TdModelNotFoundException>(),
        ),
      );
    });
  });

  group('caller', () {
    test('find zero', () async {
      final ds = await ftp.tdCallers(
        startsWith: 'A',
        tdBranch: TdBranch(id: 'g', name: 'EEE Branch'),
      );

      expect(ds.length, isZero);
    });

    test('find two', () async {
      final ds = await ftp.tdCallers(
        startsWith: 'b',
        tdBranch: TdBranch(
          id: 'b',
          name: 'a name',
        ),
      );

      expect(ds.length, 2);
    });

    test('has avatar', () async {
      final ds = await ftp.tdCallers(
          startsWith: 'Augustin Sheryll',
          tdBranch: TdBranch(
            id: 'a',
            name: 'a name',
          ));

      expect(ds.length, 1);
      expect(ds.first.avatar.length, isNonZero);
    });

    test('by id find one', () async {
      final caa = await ftp.tdCaller(id: 'aa');

      expect(caa.id, 'aa');
      expect(caa.avatar.length, isNonZero);
    });

    test('by non-existent id throws', () async {
      expect(
        ftp.tdCaller(id: 'doesnotexist'),
        throwsA(
          const TypeMatcher<TdModelNotFoundException>(),
        ),
      );
    });
  });

  group('category', () {
    test('find all', () async {
      expect((await ftp.tdCategories()).length, 3);
    });

    test('by id find one', () async {
      final ca = await ftp.tdCategory(id: 'a');
      expect(ca.id, 'a');
    });

    test('by non-existent id throws', () async {
      expect(
        ftp.tdCategory(id: 'doesnotexist'),
        throwsA(
          const TypeMatcher<TdModelNotFoundException>(),
        ),
      );
    });
  });

  group('sub category', () {
    test('find all for one category', () async {
      final ca = await ftp.tdCategory(id: 'a');
      expect((await ftp.tdSubcategories(tdCategory: ca)).length, 4);
    });

    test('by id find one', () async {
      final scaa = await ftp.tdSubcategory(id: 'aa');
      expect(scaa.id, 'aa');
    });

    test('by non-existent id throws', () async {
      expect(
        ftp.tdSubcategory(id: 'doesnotexist'),
        throwsA(
          const TypeMatcher<TdModelNotFoundException>(),
        ),
      );
    });
  });

  group('duration', () {
    test('find all', () async {
      final ds = await ftp.tdDurations();
      expect(ds.length, 7);
    });

    test('by id find one', () async {
      final ida = await ftp.tdDuration(id: 'a');
      expect(ida.id, 'a');
    });

    test('by non-existent id throws', () async {
      expect(
        ftp.tdDuration(id: 'doesnotexist'),
        throwsA(
          const TypeMatcher<TdModelNotFoundException>(),
        ),
      );
    });
  });

  group('operator', () {
    test('find zero', () async {
      final ds = await ftp.tdOperators(startsWith: 'Q');

      expect(ds.length, isZero);
    });

    test('find one', () async {
      final ds = await ftp.tdOperators(
        startsWith: 'b',
      );

      expect(ds.length, 1);
    });

    test('has avatar', () async {
      final ds = await ftp.tdOperators(
        startsWith: 'Eduard',
      );

      expect(ds.length, 1);
      expect(ds.first.avatar.length, isNonZero);
    });

    test('current operator has avatar', () async {
      final op = await ftp.currentTdOperator();

      expect(op.avatar.length, isNonZero);
    });

    test('by id find one', () async {
      final oa = await ftp.tdOperator(id: 'a');
      expect(oa.id, 'a');
    });

    test('by non-existent id throws', () async {
      expect(
        ftp.tdOperator(id: 'doesnotexist'),
        throwsA(
          TypeMatcher<TdModelNotFoundException>(),
        ),
      );
    });
  });

  group('incident', () {
    test('create', () async {
      final number = await ftp.createTdIncident(
        briefDescription: 'brief description',
        settings: Settings(),
      );

      expect(number, isNotNull);
    });
  });
}
