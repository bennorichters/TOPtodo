import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:toptodo_data/toptodo_data.dart';

import 'package:toptodo_topdesk_provider_mock/toptodo_topdesk_provider_mock.dart';

void main() {
  testWidgets('fetch durations', (WidgetTester t) async {
    await t.runAsync(() async {
      final FakeTopdeskProvider ftp = FakeTopdeskProvider(
        latency: const Duration(microseconds: 1),
      );
      final Iterable<IncidentDuration> ds = await ftp.durations();

      await t.pump(const Duration(milliseconds: 1));

      expect(ds.length, isNonZero);
    });
  });

  testWidgets('fetch branches', (WidgetTester t) async {
    await t.runAsync(() async {
      final FakeTopdeskProvider ftp = FakeTopdeskProvider(
        latency: const Duration(microseconds: 0),
      );
      final Iterable<Branch> ds = await ftp.branches(startsWith: 'E');

      await t.pump(const Duration(milliseconds: 10));

      expect(ds.length, 3);
    });
  });

  testWidgets('fetch zero persons', (WidgetTester t) async {
    await t.runAsync(() async {
      final FakeTopdeskProvider ftp = FakeTopdeskProvider(
        latency: const Duration(microseconds: 0),
      );
      final Iterable<Caller> ds = await ftp.callers(
        startsWith: 'A',
        branch: Branch.fromJson(
          jsonDecode('{"id": "g", "name": "EEE Branch"}'),
        ),
      );

      await t.pump(const Duration(milliseconds: 10));

      expect(ds.length, isZero);
    });
  });

  testWidgets('fetch two persons', (WidgetTester t) async {
    await t.runAsync(() async {
      final FakeTopdeskProvider ftp = FakeTopdeskProvider(
        latency: const Duration(microseconds: 0),
      );
      final Iterable<Caller> ds = await ftp.callers(
        startsWith: 'b',
        branch: Branch.fromJson(
          jsonDecode('{"id": "b", "name": ""}'),
        ),
      );

      await t.pump(const Duration(milliseconds: 10));

      expect(ds.length, 2);
    });
  });

  testWidgets('fetch current operator', (WidgetTester t) async {
    await t.runAsync(() async {
      final FakeTopdeskProvider ftp = FakeTopdeskProvider(
        latency: const Duration(microseconds: 0),
      );
      final Operator op = await ftp.currentOperator();
      await t.pump(const Duration(milliseconds: 10));

      expect(op, isNotNull);
    });
  });
}
