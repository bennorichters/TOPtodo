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
    const String defaultJson = '[{"id": "a", "name": "ABA"},'
        '{"id": "b", "name": "DEF"},'
        '{"id": "c", "name": "ABB"}]';

    ApiTopdeskProvider apiTopdeskProvider({
      String expectedPath,
      Map<String, String> expectedQueryParameters,
      String responseJson,
    }) {
      final Client client = MockClient((Request request) async {
        if (expectedPath != null) {
          expect(request.url.path, credentials.url + '/' + expectedPath);
        }

        if (expectedQueryParameters != null) {
          expect(request.url.queryParameters, expectedQueryParameters);
        }

        return Response(
          responseJson ?? defaultJson,
          200,
        );
      });

      final ApiTopdeskProvider atp = ApiTopdeskProvider()
        ..init(
          credentials,
          client: client,
        );

      return atp;
    }

    group('branch', () {
      test('find by id', () async {
        final ApiTopdeskProvider atp = apiTopdeskProvider(
          expectedPath: 'tas/api/branches/id/a',
        );
        final Branch b = await atp.branch(id: 'a');

        expect(b.id, 'a');
      });

      test('find by nonexisting id throws', () async {
        final ApiTopdeskProvider atp = apiTopdeskProvider();
        expect(
          atp.branch(id: 'doesnotexist'),
          throwsA(
            const TypeMatcher<TdModelNotFoundException>(),
          ),
        );
      });

      test('starts with find two', () async {
        final ApiTopdeskProvider atp = apiTopdeskProvider(
          expectedPath: 'tas/api/branches',
          expectedQueryParameters: <String, String>{
            '\$fields': 'id,name',
            'nameFragment': 'ab',
          },
          responseJson: '[{"id": "a", "name": "ABA"},'
              '{"id": "c", "name": "ABB"}]',
        );
        final Iterable<Branch> bs = await atp.branches(startsWith: 'ab');
        expect(bs.length, 2);
      });
    });

    group('category', () {
      test('find by id', () async {
        final ApiTopdeskProvider atp = apiTopdeskProvider(
          expectedPath: 'tas/api/incidents/categories',
        );
        final Category c = await atp.category(id: 'a');

        expect(c.id, 'a');
      });

      test('find by nonexisting id throws', () async {
        final ApiTopdeskProvider atp = apiTopdeskProvider();
        expect(
          atp.category(id: 'doesnotexist'),
          throwsA(
            const TypeMatcher<TdModelNotFoundException>(),
          ),
        );
      });

      test('find three', () async {
        final ApiTopdeskProvider atp = apiTopdeskProvider(
          expectedPath: 'tas/api/incidents/categories',
        );
        final Iterable<Category> cs = await atp.categories();

        expect(cs.length, 3);
        expect(cs.first.id, 'a');
      });
    });

    group('duration', () {
      test('find by id', () async {
        final ApiTopdeskProvider atp = apiTopdeskProvider(
          expectedPath: 'tas/api/incidents/durations',
        );
        final IncidentDuration id = await atp.incidentDuration(id: 'a');

        expect(id.id, 'a');
      });

      test('find by nonexisting id throws', () async {
        final ApiTopdeskProvider atp = apiTopdeskProvider();
        expect(
          atp.incidentDuration(id: 'doesnotexist'),
          throwsA(
            const TypeMatcher<TdModelNotFoundException>(),
          ),
        );
      });

      test('find three', () async {
        final ApiTopdeskProvider atp = apiTopdeskProvider(
          expectedPath: 'tas/api/incidents/durations',
        );
        final Iterable<IncidentDuration> ids = await atp.incidentDurations();

        expect(ids.length, 3);
        expect(ids.first.id, 'a');
      });
    });
  });
}
