import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:toptodo_data/toptodo_data.dart';
import 'package:toptodo_topdesk_provider_api/api_topdesk_provider.dart';

void main() {
  final Credentials credentials = Credentials(
    url: 'a',
    loginName: 'userA',
    password: 'S3CrEt!',
  );

  group('errors', () {
    test('StateError without init', () async {
      final ApiTopdeskProvider atp = ApiTopdeskProvider();
      expect(atp.branches(startsWith: ''), throwsStateError);
    });
  });

  group('meta', () {
    test('headers', () async {
      Map<String, String> headers;
      final MockClient mc = MockClient((Request req) async {
        headers = req.headers;
        return Response('[]', 200);
      });

      final ApiTopdeskProvider atp = ApiTopdeskProvider();
      atp.init(credentials, client: mc);
      await atp.incidentDurations();

      expect(headers['accept'], 'application/json');

      expect(headers['authorization'].startsWith('Basic '), isTrue);
      final String decoded = utf8
          .fuse(base64)
          .decode(headers['authorization'].substring('Basic '.length));
      expect(decoded, credentials.loginName + ':' + credentials.password);
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
    atp.init(credentials, client: mc);
    final Iterable<IncidentDuration> ids = await atp.incidentDurations();

    expect(url.path, 'a/tas/api/incidents/durations');
    expect(ids.length, 2);
    expect(ids.first.id, 'a');
  });
}
