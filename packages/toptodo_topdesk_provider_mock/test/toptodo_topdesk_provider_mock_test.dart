import 'package:flutter_test/flutter_test.dart';
import 'package:toptodo_data/toptodo_data.dart';

import 'package:toptodo_topdesk_provider_mock/toptodo_topdesk_provider_mock.dart';

void main() {
  testWidgets('asset reading', (WidgetTester t) async {
    final FakeTopdeskProvider ftp = FakeTopdeskProvider();
    final Iterable<IncidentDuration> ds = await ftp.fetchDurations();
    expect(ds.length, isNonZero);
  });
}
