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

  group('api call', () {
    final Response resp = Response(
      '[{"id": "a", "name": "ABC"},'
      '{"id": "b", "name": "DEF"},'
      '{"id": "c", "name": "GHI"}]',
      200,
    );

    group('branch', () {});

    group('category', () {
      test('find by id', () async {
        Uri url;
        final MockClient mc = MockClient((Request req) async {
          url = req.url;
          return resp;
        });

        final ApiTopdeskProvider atp = ApiTopdeskProvider();
        atp.init(credentials, client: mc);
        final Category c = await atp.category(id: 'a');

        expect(url.path, 'a/tas/api/incidents/categories');
        expect(c.id, 'a');
      });

      test('find by nonexisting id throws', () async {
        final MockClient mc = MockClient((Request req) async {
          return resp;
        });

        final ApiTopdeskProvider atp = ApiTopdeskProvider();
        atp.init(credentials, client: mc);
        expect(
          atp.category(id: 'doesnotexist'),
          throwsA(
            const TypeMatcher<TdModelNotFoundException>(),
          ),
        );
      });

      test('find three', () async {
        Uri url;
        final MockClient mc = MockClient((Request req) async {
          url = req.url;
          return resp;
        });

        final ApiTopdeskProvider atp = ApiTopdeskProvider();
        atp.init(credentials, client: mc);
        final Iterable<Category> cs = await atp.categories();

        expect(url.path, 'a/tas/api/incidents/categories');
        expect(cs.length, 3);
        expect(cs.first.id, 'a');
      });
    });

    group('duration', () {
      test('find by id', () async {
        Uri url;
        final MockClient mc = MockClient((Request req) async {
          url = req.url;
          return resp;
        });

        final ApiTopdeskProvider atp = ApiTopdeskProvider();
        atp.init(credentials, client: mc);
        final IncidentDuration id = await atp.incidentDuration(id: 'a');

        expect(url.path, 'a/tas/api/incidents/durations');
        expect(id.id, 'a');
      });

      test('find by nonexisting id throws', () async {
        final MockClient mc = MockClient((Request req) async {
          return resp;
        });

        final ApiTopdeskProvider atp = ApiTopdeskProvider();
        atp.init(credentials, client: mc);
        expect(
          atp.incidentDuration(id: 'doesnotexist'),
          throwsA(
            const TypeMatcher<TdModelNotFoundException>(),
          ),
        );
      });

      test('find three', () async {
        Uri url;
        final MockClient mc = MockClient((Request req) async {
          url = req.url;
          return resp;
        });

        final ApiTopdeskProvider atp = ApiTopdeskProvider();
        atp.init(credentials, client: mc);
        final Iterable<IncidentDuration> ids = await atp.incidentDurations();

        expect(url.path, 'a/tas/api/incidents/durations');
        expect(ids.length, 3);
        expect(ids.first.id, 'a');
      });
    });
  });
}
