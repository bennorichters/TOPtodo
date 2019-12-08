import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test/flutter_test.dart' as prefix0;
import 'package:toptodo_data/toptodo_data.dart';

import 'package:toptodo_topdesk_provider_mock/toptodo_topdesk_provider_mock.dart';

void main() {
  testWidgets('fetch durations', (WidgetTester t) async {
    await t.runAsync(() async {
      final FakeTopdeskProvider ftp = FakeTopdeskProvider(
        latency: const Duration(microseconds: 1),
      );
      final Iterable<IncidentDuration> ds = await ftp.fetchDurations();

      await t.pump(const Duration(milliseconds: 1));

      expect(ds.length, isNonZero);
    });
  });

  testWidgets('fetch branches', (WidgetTester t) async {
    await t.runAsync(() async {
      final FakeTopdeskProvider ftp = FakeTopdeskProvider(
        latency: const Duration(microseconds: 0),
      );
      final Iterable<Branch> ds = await ftp.fetchBranches(startsWith: 'E');

      await t.pump(const Duration(milliseconds: 10));

      expect(ds.length, 3);
    });
  });

  testWidgets('fetch persons', (WidgetTester t) async {
    await t.runAsync(() async {
      final FakeTopdeskProvider ftp = FakeTopdeskProvider(
        latency: const Duration(microseconds: 0),
      );
      final Iterable<Person> ds = await ftp.fetchPersons(
        startsWith: 'A',
        branch: Branch.fromJson(
          jsonDecode('{"id": "g", "name": "EEE Branch"}'),
        ),
      );

      await t.pump(const Duration(milliseconds: 10));

      expect(ds.length, isZero);
    });
  });

  testWidgets('fetch current operator', (WidgetTester t) async {
    await t.runAsync(() async {
      final FakeTopdeskProvider ftp = FakeTopdeskProvider(
        latency: const Duration(microseconds: 0),
      );
      final Operator op = await ftp.fetchCurrentOperator();
      await t.pump(const Duration(milliseconds: 10));

      expect(op, isNotNull);
    });
  });
}
