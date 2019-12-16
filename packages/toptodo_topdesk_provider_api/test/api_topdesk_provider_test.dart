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

    test('StateError after dispose', () async {
      final ApiTopdeskProvider atp = ApiTopdeskProvider();
      atp.init(credentials);
      atp.dispose();
      expect(atp.branches(startsWith: ''), throwsStateError);
    });

    test('call init twice throws', () {
      final ApiTopdeskProvider atp = ApiTopdeskProvider();
      atp.init(credentials);

      expect(() => atp.init(credentials), throwsStateError);
    });

    test('403', () async {
      final Client client = MockClient((Request request) async {
        return Response('', 403);
      });

      final ApiTopdeskProvider atp = ApiTopdeskProvider()
        ..init(
          credentials,
          client: client,
        );

      expect(
        atp.branches(startsWith: 'xyz'),
        throwsA(
          const TypeMatcher<TdNotAuthorizedException>(),
        ),
      );
    });
  });

  group('special', () {
    test('no entities found', () async {
      final Client client = MockClient((Request request) async {
        return Response(
          '{"message": "No entitites found"}',
          204,
        );
      });

      final ApiTopdeskProvider atp = ApiTopdeskProvider()
        ..init(
          credentials,
          client: client,
        );

      final Iterable<Branch> branches = await atp.branches(startsWith: 'xyz');
      expect(branches.length, isZero);
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

      test('sanatized starts with', () async {
        final ApiTopdeskProvider atp = basicApiTopdeskProvider(
          expectedPath: 'tas/api/branches',
          expectedQueryParameters: <String, String>{
            '\$fields': 'id,name',
            'nameFragment': 'a&hourlyRate=50',
          },
          responseJson: '[{"id": "a", "name": "ABA"},'
              '{"id": "c", "name": "ABB"}]',
        );

        await atp.branches(
          startsWith: 'a&hourlyRate=50',
        );
      });
    });

    group('caller', () {
      final Branch branchForCaller = Branch.fromJson(const <String, String>{
        'id': 'a',
        'name': 'branchA',
      });

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

        final Iterable<Caller> cs = await atp.callers(
          branch: branchForCaller,
          startsWith: 'ab',
        );

        expect(cs.length, 2);
        expect(cs.first.id, 'aa');
        expect(cs.first.avatar, 'avatarForaa');
        expect(cs.last.id, 'ac');
        expect(cs.last.avatar, 'avatarForac');
      });

      test('sanatized starts with', () async {
        final ApiTopdeskProvider atp = personApiTopdeskProvider(
          personPath: 'tas/api/persons',
          expectedPersonQueryParameters: const <String, String>{
            '\$fields': 'id,dynamicName',
            'lastname': 'a&hourlyRate=50',
          },
          personResponseJson:
              '[{"id": "aa", "name": "Augustin Sheryll", "branchid": "a"}]',
          avatarPath: 'tas/api/avatars/person/',
          personIds: <String>{'aa'},
        );

        await atp.callers(
          branch: branchForCaller,
          startsWith: 'a&hourlyRate=50',
        );
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
      const String subCategoryJson = '[{'
          '"id": "aa", "name": "Climate Control", '
          '"category": {"id": "a", "name": "Building Areas"}'
          '},'
          '{"id": "ab", "name": "somethingelse", '
          '"category": {"id": "b", "name": "Other"}'
          '},'
          '{"id": "ac", "name": "Elevators", '
          '"category": {"id": "a", "name": "Building Areas"}'
          '}]';

      test('find by id', () async {
        final ApiTopdeskProvider atp = basicApiTopdeskProvider(
          expectedPath: 'tas/api/incidents/subcategories',
          responseJson: subCategoryJson,
        );

        final SubCategory sc = await atp.subCategory(id: 'ab');
        expect(sc.id, 'ab');
      });

      test('find by non existing id throws', () async {
        final ApiTopdeskProvider atp = basicApiTopdeskProvider(
          responseJson: subCategoryJson,
        );

        expect(
          atp.subCategory(id: 'doesnotexist'),
          throwsA(
            const TypeMatcher<TdModelNotFoundException>(),
          ),
        );
      });

      test('find by category', () async {
        final ApiTopdeskProvider atp = basicApiTopdeskProvider(
          expectedPath: 'tas/api/incidents/subcategories',
          responseJson: subCategoryJson,
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
        expect(subCats.last.id, 'ac');
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

    group('operator', () {
      test('find by id', () async {
        final ApiTopdeskProvider atp = personApiTopdeskProvider(
          personPath: 'tas/api/operators/id/a',
          expectedPersonQueryParameters: <String, String>{},
          personResponseJson: '{"id": "a", "name": "Augustin Sheryll"}',
          avatarPath: 'tas/api/avatars/operator/',
          personIds: <String>{'a'},
        );

        final IncidentOperator op = await atp.incidentOperator(id: 'a');

        expect(op.id, 'a');
        expect(op.avatar, 'avatarFora');
      });

      test('find by non existing id throws', () {
        final ApiTopdeskProvider atp = basicApiTopdeskProvider(
          responseCode: 404,
          responseJson: '',
        );
        expect(
          atp.incidentOperator(id: 'doesnotexist'),
          throwsA(
            const TypeMatcher<TdModelNotFoundException>(),
          ),
        );
      });

      test('find by starts with', () async {
        final ApiTopdeskProvider atp = personApiTopdeskProvider(
          personPath: 'tas/api/operators',
          expectedPersonQueryParameters: const <String, String>{
            'lastname': 'a',
          },
          personResponseJson: '['
              '{"id": "a", "name": "Aagje", '
              '  "firstLineCallOperator": true},'
              '{"id": "b", "name": "Ad", '
              '  "firstLineCallOperator": false},'
              '{"id": "c", "name": "Albert", '
              '  "firstLineCallOperator": true}'
              ']',
          avatarPath: 'tas/api/avatars/operator/',
          personIds: <String>{'a', 'c'},
        );

        final Iterable<IncidentOperator> os =
            await atp.incidentOperators(startsWith: 'a');

        expect(os.length, 2);
        expect(os.first.id, 'a');
        expect(os.first.avatar, 'avatarFora');
        expect(os.last.id, 'c');
        expect(os.last.avatar, 'avatarForc');
      });

      test('current', () async {
        final ApiTopdeskProvider atp = personApiTopdeskProvider(
          personPath: 'tas/api/operators/current',
          expectedPersonQueryParameters: const <String, String>{},
          personResponseJson: '{"id": "a", "name": "Aagje"}',
          avatarPath: 'tas/api/avatars/operator/',
          personIds: <String>{'a'},
        );

        final IncidentOperator co = await atp.currentIncidentOperator();
        expect(co.id, 'a');
        expect(co.avatar, 'avatarFora');
      });

      test('sanatized starts with', () async {
        final ApiTopdeskProvider atp = personApiTopdeskProvider(
          personPath: 'tas/api/operators',
          expectedPersonQueryParameters: const <String, String>{
            'lastname': 'a&hourlyRate=50',
          },
          personResponseJson: '[{"id": "a", "name": "Aagje", '
              '"firstLineCallOperator": true}]',
          avatarPath: 'tas/api/avatars/operator/',
          personIds: <String>{'a'},
        );

        await atp.incidentOperators(
          startsWith: 'a&hourlyRate=50',
        );
      });
    });
  });
}
