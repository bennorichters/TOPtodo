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

    ApiTopdeskProvider basicApiTopdeskProvider({
      String expectedPath,
      Map<String, String> expectedQueryParameters,
      int responseCode,
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
          responseCode ?? 200,
        );
      });

      return ApiTopdeskProvider()
        ..init(
          credentials,
          client: client,
        );
    }

    ApiTopdeskProvider personApiTopdeskProvider({
      String personPath,
      Map<String, String> expectedPersonQueryParameters,
      String personResponseJson,
      String avatarPath,
      Set<String> personIds,
    }) {
      final Client client = MockClient((Request req) async {
        final String path = req.url.path.substring(
          credentials.url.length + 1,
        );
        if (path == personPath) {
          expect(
            req.url.queryParameters,
            expectedPersonQueryParameters,
          );
          return Response(personResponseJson, 200);
        } else if (path.startsWith(avatarPath)) {
          final String id = path.substring(avatarPath.length);
          expect(
            personIds.contains(id),
            isTrue,
            reason: 'unexpected request for avatar with caller id $id',
          );

          return Response('{"image": "avatarFor$id"}', 200);
        } else {
          fail('unexpected call to endpoint: $path');
        }
      });

      return ApiTopdeskProvider()
        ..init(
          credentials,
          client: client,
        );
    }

    group('branch', () {
      test('find by id', () async {
        final ApiTopdeskProvider atp = basicApiTopdeskProvider(
          expectedPath: 'tas/api/branches/id/a',
          responseJson: '{"id": "a", "name": "ABA"}',
        );
        final Branch b = await atp.branch(id: 'a');

        expect(b.id, 'a');
      });

      test('find by nonexisting id throws', () async {
        final ApiTopdeskProvider atp = basicApiTopdeskProvider(
          responseCode: 404,
          responseJson: '',
        );
        expect(
          atp.branch(id: 'doesnotexist'),
          throwsA(
            const TypeMatcher<TdModelNotFoundException>(),
          ),
        );
      });

      test('starts with find two', () async {
        final ApiTopdeskProvider atp = basicApiTopdeskProvider(
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

    group('caller', () {
      test('find by id', () async {
        final ApiTopdeskProvider atp = personApiTopdeskProvider(
          personPath: 'tas/api/persons/id/aa',
          expectedPersonQueryParameters: <String, String>{
            '\$fields': 'id,dynamicName',
          },
          personResponseJson:
              '{"id": "aa", "name": "Augustin Sheryll", "branchid": "a"}',
          avatarPath: 'tas/api/avatars/person/',
          personIds: <String>{'aa'},
        );

        final Caller c = await atp.caller(id: 'aa');

        expect(c.id, 'aa');
        expect(c.branchid, 'a');
        expect(c.avatar, 'avatarForaa');
      });

      test('find by nonexisting id throws', () async {
        final ApiTopdeskProvider atp = basicApiTopdeskProvider(
          responseCode: 404,
          responseJson: '',
        );
        expect(
          atp.caller(id: 'doesnotexist'),
          throwsA(
            const TypeMatcher<TdModelNotFoundException>(),
          ),
        );
      });

      test('starts with find two', () async {
        final ApiTopdeskProvider atp = personApiTopdeskProvider(
          personPath: 'tas/api/persons',
          expectedPersonQueryParameters: <String, String>{
            '\$fields': 'id,dynamicName',
            'lastname': 'ab',
          },
          personResponseJson:
              '[{"id": "aa", "name": "Augustin Sheryll", "branchid": "a"},'
              '{"id": "ac", "name": "Bazile Tonette", "branchid": "a"}]',
          avatarPath: 'tas/api/avatars/person/',
          personIds: <String>{'aa', 'ac'},
        );

        final Branch branchForCaller = Branch.fromJson(const <String, String>{
          'id': 'a',
          'name': 'branchA',
        });

        final Iterable<Caller> cs = await atp.callers(
          branch: branchForCaller,
          startsWith: 'ab',
        );

        expect(cs.length, 2);
        expect(cs.first.id, 'aa');
        expect(cs.first.avatar, 'avatarForaa');
        expect(cs.first.branchid, 'a');
        expect(cs.last.id, 'ac');
        expect(cs.last.avatar, 'avatarForac');
        expect(cs.last.branchid, 'a');
      });
    });

    group('category', () {
      test('find by id', () async {
        final ApiTopdeskProvider atp = basicApiTopdeskProvider(
          expectedPath: 'tas/api/incidents/categories',
        );
        final Category c = await atp.category(id: 'a');

        expect(c.id, 'a');
      });

      test('find by nonexisting id throws', () async {
        final ApiTopdeskProvider atp = basicApiTopdeskProvider();
        expect(
          atp.category(id: 'doesnotexist'),
          throwsA(
            const TypeMatcher<TdModelNotFoundException>(),
          ),
        );
      });

      test('find three', () async {
        final ApiTopdeskProvider atp = basicApiTopdeskProvider(
          expectedPath: 'tas/api/incidents/categories',
        );
        final Iterable<Category> cs = await atp.categories();

        expect(cs.length, 3);
        expect(cs.first.id, 'a');
      });
    });

    group('subcategory', () {
      test('find by id', () {});

      test('find by non existing id throws', () {});

      test('find by category', () async {
        final ApiTopdeskProvider atp = basicApiTopdeskProvider(
          expectedPath: 'tas/api/incidents/subcategories',
          responseJson: '[{'
              '"id": "aa", "name": "Climate Control", '
              '"category": {"id": "a", "name": "Building Areas"}'
              '},'
              '{"id": "ab", "name": "Elevators", '
              '"category": {"id": "a", "name": "Building Areas"}'
              '}]',
        );

        final Category cat = Category.fromJson(
          const <String, String>{
            'id': 'a',
            'name': 'catA',
          },
        );

        final Iterable<SubCategory> subCats = await atp.subCategories(
          category: cat,
        );
        expect(subCats.length, 2);
        expect(subCats.first.id, 'aa');
        expect(subCats.first.categoryId, 'a');
        expect(subCats.last.id, 'ac');
        expect(subCats.last.categoryId, 'a');
      });
    });

    group('duration', () {
      test('find by id', () async {
        final ApiTopdeskProvider atp = basicApiTopdeskProvider(
          expectedPath: 'tas/api/incidents/durations',
        );
        final IncidentDuration id = await atp.incidentDuration(id: 'a');

        expect(id.id, 'a');
      });

      test('find by nonexisting id throws', () async {
        final ApiTopdeskProvider atp = basicApiTopdeskProvider();
        expect(
          atp.incidentDuration(id: 'doesnotexist'),
          throwsA(
            const TypeMatcher<TdModelNotFoundException>(),
          ),
        );
      });

      test('find three', () async {
        final ApiTopdeskProvider atp = basicApiTopdeskProvider(
          expectedPath: 'tas/api/incidents/durations',
        );
        final Iterable<IncidentDuration> ids = await atp.incidentDurations();

        expect(ids.length, 3);
        expect(ids.first.id, 'a');
      });
    });
  });
}
