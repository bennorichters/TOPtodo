import 'package:flutter_test/flutter_test.dart';
import 'package:toptodo_data/toptodo_data.dart';

import 'package:toptodo_topdesk_provider_mock/toptodo_topdesk_provider_mock.dart';

void main() {
  testWidgets('fetch durations', (WidgetTester t) async {
    final FakeTopdeskProvider ftp = FakeTopdeskProvider();
    final Iterable<IncidentDuration> ds = await ftp.fetchDurations();
    expect(ds.length, isNonZero);
  });

  testWidgets('fetch branches', (WidgetTester t) async {
    final FakeTopdeskProvider ftp = FakeTopdeskProvider();
    final Iterable<Branch> ds = await ftp.fetchBranches(startsWith: 'E');
    expect(ds.length, 3);
  });

  testWidgets('fetch persons', (WidgetTester t) async {
    final FakeTopdeskProvider ftp = FakeTopdeskProvider();
    final Iterable<Person> ds = await ftp.fetchPersons(
      startsWith: 'A',
      branchId: 'x',
    );
    expect(ds.length, isZero);
  });
}
