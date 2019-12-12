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

  test('...', () async {
    final MockClient mc = MockClient((Request req) async {
      return Response('[]', 200);
    });

    final ApiTopdeskProvider atp = ApiTopdeskProvider();
    final Credentials c = Credentials(
      url: 'a',
      loginName: 'b',
      password: 'c',
    );

    atp.init(c, client: mc);
    final Iterable<IncidentDuration> ids = await atp.incidentDurations();
    print(ids);
  });
}
