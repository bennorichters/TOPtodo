import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:toptodo_data/toptodo_data.dart';
import 'package:toptodo_topdesk_provider_api/api_topdesk_provider.dart';

void main() {
  group('errors', () {
    test('StateError without init', () async {
      final ApiTopdeskProvider atp = ApiTopdeskProvider();
      expect(atp.branches(startsWith: ''), throwsStateError);
    });
  });

  test('two durations', () async {
    Uri url;
    final MockClient mc = MockClient((Request req) async {
     url = req.url;
      return Response(
          '[{"id": "a", "name": "15 minutes"},'
          '{"id": "b", "name": "30 minutes"}]',
          200);
    });

    final ApiTopdeskProvider atp = ApiTopdeskProvider();
    final Credentials c = Credentials(
      url: 'a',
      loginName: 'b',
      password: 'c',
    );

    atp.init(c, client: mc);
    final Iterable<IncidentDuration> ids = await atp.incidentDurations();

    expect(url.path, 'a/tas/api/incidents/durations');
    expect(ids.length, 2);
    expect(ids.first.id, 'a');
  });
}
