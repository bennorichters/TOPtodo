import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:toptodo_data/toptodo_data.dart';

import 'package:toptodo_topdesk_provider_mock/toptodo_topdesk_provider_mock.dart';

void main() {
  final FakeTopdeskProvider ftp = FakeTopdeskProvider(
    latency: const Duration(microseconds: 0),
  );

  testWidgets('branches', (WidgetTester t) async {
    await t.runAsync(() async {
      final Iterable<Branch> ds = await ftp.branches(startsWith: 'E');

      await t.pump(const Duration(milliseconds: 10));

      expect(ds.length, 3);
    });
  });

  testWidgets('branch by id', (WidgetTester t) async {
    await t.runAsync(() async {
      final Branch ba = await ftp.branch(id: 'a');

      await t.pump(const Duration(milliseconds: 10));

      expect(ba.id, 'a');
    });
  });

  testWidgets('durations', (WidgetTester t) async {
    await t.runAsync(() async {
      final Iterable<IncidentDuration> ds = await ftp.incidentDurations();

      await t.pump(const Duration(milliseconds: 1));

      expect(ds.length, isNonZero);
    });
  });
  testWidgets('zero persons', (WidgetTester t) async {
    await t.runAsync(() async {
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

  testWidgets('two persons', (WidgetTester t) async {
    await t.runAsync(() async {
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

  testWidgets('person has avatar', (WidgetTester t) async {
    await t.runAsync(() async {
      final Iterable<Caller> ds = await ftp.callers(
        startsWith: 'Augustin Sheryll',
        branch: Branch.fromJson(
          jsonDecode('{"id": "a", "name": ""}'),
        ),
      );

      await t.pump(const Duration(milliseconds: 10));

      expect(ds.length, 1);
      expect(ds.first.avatar.length, isNonZero);
    });
  });

  testWidgets('zero operators', (WidgetTester t) async {
    await t.runAsync(() async {
      final Iterable<IncidentOperator> ds = await ftp.operators(
        startsWith: 'Q',
      );

      await t.pump(const Duration(milliseconds: 10));

      expect(ds.length, isZero);
    });
  });

  testWidgets('one operators', (WidgetTester t) async {
    await t.runAsync(() async {
      final Iterable<IncidentOperator> ds = await ftp.operators(
        startsWith: 'b',
      );

      await t.pump(const Duration(milliseconds: 10));

      expect(ds.length, 1);
    });
  });

  testWidgets('operator has avatar', (WidgetTester t) async {
    await t.runAsync(() async {
      final Iterable<Caller> ds = await ftp.callers(
        startsWith: 'Augustin Sheryll',
        branch: Branch.fromJson(
          jsonDecode('{"id": "a", "name": ""}'),
        ),
      );

      await t.pump(const Duration(milliseconds: 10));

      expect(ds.length, 1);
      expect(ds.first.avatar.length, isNonZero);
    });
  });

  testWidgets('operator has avatar', (WidgetTester t) async {
    await t.runAsync(() async {
      final Iterable<IncidentOperator> ds = await ftp.operators(
        startsWith: 'Eduard',
      );

      await t.pump(const Duration(milliseconds: 10));

      expect(ds.length, 1);
      expect(ds.first.avatar.length, isNonZero);
    });
  });

  testWidgets('current operator has avatar', (WidgetTester t) async {
    await t.runAsync(() async {
      final IncidentOperator op = await ftp.currentIncidentOperator();

      await t.pump(const Duration(milliseconds: 10));

      expect(op.avatar.length, isNonZero);
    });
  });
}
