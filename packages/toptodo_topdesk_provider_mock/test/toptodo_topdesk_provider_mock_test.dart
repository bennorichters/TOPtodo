import 'dart:convert';

import 'package:test/test.dart';
import 'package:toptodo_data/toptodo_data.dart';
import 'package:toptodo_topdesk_provider_mock/toptodo_topdesk_provider_mock.dart';

void main() {
  final FakeTopdeskProvider ftp = FakeTopdeskProvider(
    latency: const Duration(microseconds: 0),
  );

  group('branches', () {
    test('find some', () async {
      final Iterable<Branch> ds = await ftp.branches(startsWith: 'E');
      expect(ds.length, 3);
    });

    test('branch by id find one', () async {
      final Branch ba = await ftp.branch(id: 'a');

      expect(ba.id, 'a');
    });

    test('branch by id find null', () async {
      expect(ftp.branch(id: 'doesnotexist'), throwsArgumentError);
    });
  });

  group('callers', () {
    test('zero callers', () async {
      final Iterable<Caller> ds = await ftp.callers(
        startsWith: 'A',
        branch: Branch.fromJson(
          jsonDecode('{"id": "g", "name": "EEE Branch"}'),
        ),
      );

      expect(ds.length, isZero);
    });

    test('two callers', () async {
      final Iterable<Caller> ds = await ftp.callers(
        startsWith: 'b',
        branch: Branch.fromJson(
          jsonDecode('{"id": "b", "name": ""}'),
        ),
      );

      expect(ds.length, 2);
    });

    test('caller has avatar', () async {
      final Iterable<Caller> ds = await ftp.callers(
        startsWith: 'Augustin Sheryll',
        branch: Branch.fromJson(
          jsonDecode('{"id": "a", "name": ""}'),
        ),
      );

      expect(ds.length, 1);
      expect(ds.first.avatar.length, isNonZero);
    });
  });

  group('durations', () {
    test('find some', () async {
      final Iterable<IncidentDuration> ds = await ftp.incidentDurations();

      expect(ds.length, isNonZero);
    });
  });

  test('zero operators', () async {
    final Iterable<IncidentOperator> ds = await ftp.operators(
      startsWith: 'Q',
    );

    expect(ds.length, isZero);
  });

  group('operators', () {
    test('one operators', () async {
      final Iterable<IncidentOperator> ds = await ftp.operators(
        startsWith: 'b',
      );

      expect(ds.length, 1);
    });

    test('operator has avatar', () async {
      final Iterable<Caller> ds = await ftp.callers(
        startsWith: 'Augustin Sheryll',
        branch: Branch.fromJson(
          jsonDecode('{"id": "a", "name": ""}'),
        ),
      );

      expect(ds.length, 1);
      expect(ds.first.avatar.length, isNonZero);
    });

    test('operator has avatar', () async {
      final Iterable<IncidentOperator> ds = await ftp.operators(
        startsWith: 'Eduard',
      );

      expect(ds.length, 1);
      expect(ds.first.avatar.length, isNonZero);
    });

    test('current operator has avatar', () async {
      final IncidentOperator op = await ftp.currentIncidentOperator();

      expect(op.avatar.length, isNonZero);
    });
  });
}
