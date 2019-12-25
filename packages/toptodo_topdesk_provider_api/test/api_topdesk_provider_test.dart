import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:toptodo_data/toptodo_data.dart';
import 'package:toptodo_topdesk_provider_api/api_topdesk_provider.dart';

void main() {
  const credentials = Credentials(
    url: 'a',
    loginName: 'userA',
    password: 'S3CrEt!',
  );

  group('errors', () {
    test('StateError without init', () async {
      final atp = ApiTopdeskProvider();
      expect(atp.branches(startsWith: ''), throwsStateError);
    });

    test('StateError after dispose', () async {
      final atp = ApiTopdeskProvider();
      atp.init(credentials);
      atp.dispose();
      expect(atp.branches(startsWith: ''), throwsStateError);
    });

    test('call init twice throws', () {
      final atp = ApiTopdeskProvider();
      atp.init(credentials);

      expect(() => atp.init(credentials), throwsStateError);
    });

    Future<void> testErrorCode(int code, TypeMatcher<dynamic> tm) async {
      final Client client = MockClient((Request request) async {
        return Response('', code);
      });

      final atp = ApiTopdeskProvider()
        ..init(
          credentials,
          client: client,
        );

      expect(
        atp.branch(id: 'xyz'),
        throwsA(tm),
      );
    }

    test('400', () async {
      await testErrorCode(400, const TypeMatcher<ArgumentError>());
    });

    test('401', () async {
      await testErrorCode(401, const TypeMatcher<ArgumentError>());
    });

    test('402', () async {
      await testErrorCode(402, const TypeMatcher<ArgumentError>());
    });

    test('403', () async {
      await testErrorCode(403, const TypeMatcher<TdNotAuthorizedException>());
    });

    test('404', () async {
      await testErrorCode(404, const TypeMatcher<TdModelNotFoundException>());
    });

    test('500', () async {
      await testErrorCode(500, const TypeMatcher<TdServerException>());
    });

    test('client throws error', () async {
      final Client client = MockClient((Request request) async {
        throw StateError('just testing');
      });

      final atp = ApiTopdeskProvider()
        ..init(
          credentials,
          client: client,
        );

      expect(
        atp.branch(id: 'xyz'),
        throwsA(
          const TypeMatcher<TdServerException>(),
        ),
      );
    });

    test('timeout', () async {
      final Client client = MockClient((Request request) async {
        return Future<Response>.delayed(
          const Duration(milliseconds: 50),
          () => Response('{"id": "a", "name": "ABA"}', 200),
        );
      });

      final atp = ApiTopdeskProvider(
        timeOut: const Duration(milliseconds: 10),
      )..init(
          credentials,
          client: client,
        );

      expect(
        atp.branch(id: 'a'),
        throwsA(
          const TypeMatcher<TdTimeOutException>(),
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

      final atp = ApiTopdeskProvider()
        ..init(
          credentials,
          client: client,
        );

      final branches = await atp.branches(startsWith: 'xyz');
      expect(branches.length, isZero);
    });
  });

  group('meta', () {
    test('headers', () async {
      Map<String, String> headers;
      final mc = MockClient((Request req) async {
        headers = req.headers;
        return Response('[]', 200);
      });

      final atp = ApiTopdeskProvider();
      atp.init(credentials, client: mc);
      await atp.incidentDurations();

      expect(headers['accept'], 'application/json');

      expect(headers['authorization'].startsWith('Basic '), isTrue);
      final decoded = utf8
          .fuse(base64)
          .decode(headers['authorization'].substring('Basic '.length));
      expect(decoded, credentials.loginName + ':' + credentials.password);
    });
  });

  group('api call', () {
    const defaultJson = '[{"id": "a", "name": "ABA"},'
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
        final path = req.url.path.substring(
          credentials.url.length + 1,
        );
        if (path == personPath) {
          expect(
            req.url.queryParameters,
            expectedPersonQueryParameters,
          );
          return Response(personResponseJson, 200);
        } else if (path.startsWith(avatarPath)) {
          final id = path.substring(avatarPath.length);
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
        final atp = basicApiTopdeskProvider(
          expectedPath: 'tas/api/branches/id/a',
          responseJson: '{"id": "a", "name": "ABA"}',
        );
        final b = await atp.branch(id: 'a');

        expect(b.id, 'a');
      });

      test('find by nonexisting id throws', () async {
        final atp = basicApiTopdeskProvider(
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
        final atp = basicApiTopdeskProvider(
          expectedPath: 'tas/api/branches',
          expectedQueryParameters: <String, String>{
            '\$fields': 'id,name',
            'nameFragment': 'ab',
          },
          responseJson: '[{"id": "a", "name": "ABA"},'
              '{"id": "c", "name": "ABB"}]',
        );

        final bs = await atp.branches(startsWith: 'ab');
        expect(bs.length, 2);
      });

      test('sanatized starts with', () async {
        final atp = basicApiTopdeskProvider(
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
      const branchForCaller = Branch(
        id: 'a',
        name: 'branchA',
      );

      test('find by id', () async {
        final atp = personApiTopdeskProvider(
          personPath: 'tas/api/persons/id/aa',
          expectedPersonQueryParameters: <String, String>{
            '\$fields': 'id,dynamicName,branch',
          },
          personResponseJson: '{"id": "aa", "dynamicName": "Augustin Sheryll",'
              ' "branch": {"id": "a", "name": "branchA"}}',
          avatarPath: 'tas/api/avatars/person/',
          personIds: <String>{'aa'},
        );

        final c = await atp.caller(id: 'aa');

        expect(c.id, 'aa');
        expect(c.avatar, 'avatarForaa');
      });

      test('find by nonexisting id throws', () async {
        final atp = basicApiTopdeskProvider(
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
        final atp = personApiTopdeskProvider(
          personPath: 'tas/api/persons',
          expectedPersonQueryParameters: <String, String>{
            '\$fields': 'id,dynamicName,branch',
            'lastname': 'ab',
          },
          personResponseJson: '[{"id": "aa", "dynamicName": "Augustin Sheryll",'
              ' "branch": {"id": "a", "name": "branchA"}},'
              '{"id": "ac", "dynamicName": "Bazile Tonette",'
              ' "branch": {"id": "a", "name": "branchA"}}]',
          avatarPath: 'tas/api/avatars/person/',
          personIds: <String>{'aa', 'ac'},
        );

        final cs = await atp.callers(
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
        final atp = personApiTopdeskProvider(
          personPath: 'tas/api/persons',
          expectedPersonQueryParameters: const <String, String>{
            '\$fields': 'id,dynamicName,branch',
            'lastname': 'a&hourlyRate=50',
          },
          personResponseJson: '[{"id": "aa", "dynamicName": "Augustin Sheryll",'
              ' "branch": {"id": "a", "name": "branchA"}}]',
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
        final atp = basicApiTopdeskProvider(
          expectedPath: 'tas/api/incidents/categories',
        );
        final c = await atp.category(id: 'a');

        expect(c.id, 'a');
      });

      test('find by nonexisting id throws', () async {
        final atp = basicApiTopdeskProvider();
        expect(
          atp.category(id: 'doesnotexist'),
          throwsA(
            const TypeMatcher<TdModelNotFoundException>(),
          ),
        );
      });

      test('find three', () async {
        final atp = basicApiTopdeskProvider(
          expectedPath: 'tas/api/incidents/categories',
        );
        final cs = await atp.categories();

        expect(cs.length, 3);
        expect(cs.first.id, 'a');
      });
    });

    group('subcategory', () {
      const subCategoryJson = '[{'
          '"id": "aa", "name": "Climate Control",'
          ' "category": {"id": "a", "name": "Building Areas"}'
          '},'
          '{"id": "ab", "name": "somethingelse",'
          ' "category": {"id": "b", "name": "Other"}'
          '},'
          '{"id": "ac", "name": "Elevators",'
          ' "category": {"id": "a", "name": "Building Areas"}'
          '}]';

      test('find by id', () async {
        final atp = basicApiTopdeskProvider(
          expectedPath: 'tas/api/incidents/subcategories',
          responseJson: subCategoryJson,
        );

        final sc = await atp.subCategory(id: 'ab');
        expect(sc.id, 'ab');
      });

      test('find by non existing id throws', () async {
        final atp = basicApiTopdeskProvider(
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
        final atp = basicApiTopdeskProvider(
          expectedPath: 'tas/api/incidents/subcategories',
          responseJson: subCategoryJson,
        );

        const cat = Category(
          id: 'a',
          name: 'catA',
        );

        final subCats = await atp.subCategories(
          category: cat,
        );
        expect(subCats.length, 2);
        expect(subCats.first.id, 'aa');
        expect(subCats.last.id, 'ac');
      });
    });

    group('duration', () {
      test('find by id', () async {
        final atp = basicApiTopdeskProvider(
          expectedPath: 'tas/api/incidents/durations',
        );
        final id = await atp.incidentDuration(id: 'a');

        expect(id.id, 'a');
      });

      test('find by nonexisting id throws', () async {
        final atp = basicApiTopdeskProvider();
        expect(
          atp.incidentDuration(id: 'doesnotexist'),
          throwsA(
            const TypeMatcher<TdModelNotFoundException>(),
          ),
        );
      });

      test('find three', () async {
        final atp = basicApiTopdeskProvider(
          expectedPath: 'tas/api/incidents/durations',
        );
        final ids = await atp.incidentDurations();

        expect(ids.length, 3);
        expect(ids.first.id, 'a');
      });
    });

    group('operator', () {
      test('find by id', () async {
        final atp = personApiTopdeskProvider(
          personPath: 'tas/api/operators/id/a',
          expectedPersonQueryParameters: <String, String>{},
          personResponseJson: '{"id": "a", "dynamicName": "Augustin Sheryll"}',
          avatarPath: 'tas/api/avatars/operator/',
          personIds: <String>{'a'},
        );

        final op = await atp.incidentOperator(id: 'a');

        expect(op.id, 'a');
        expect(op.avatar, 'avatarFora');
      });

      test('find by non existing id throws', () {
        final atp = basicApiTopdeskProvider(
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
        final atp = personApiTopdeskProvider(
          personPath: 'tas/api/operators',
          expectedPersonQueryParameters: const <String, String>{
            'lastname': 'a',
          },
          personResponseJson: '['
              '{"id": "a", "dynamicName": "Aagje", '
              '  "firstLineCallOperator": true},'
              '{"id": "b", "dynamicName": "Ad", '
              '  "firstLineCallOperator": false},'
              '{"id": "c", "dynamicName": "Albert", '
              '  "firstLineCallOperator": true}'
              ']',
          avatarPath: 'tas/api/avatars/operator/',
          personIds: <String>{'a', 'c'},
        );

        final os = await atp.incidentOperators(startsWith: 'a');

        expect(os.length, 2);
        expect(os.first.id, 'a');
        expect(os.first.avatar, 'avatarFora');
        expect(os.last.id, 'c');
        expect(os.last.avatar, 'avatarForc');
      });

      test('current', () async {
        final atp = personApiTopdeskProvider(
          personPath: 'tas/api/operators/current',
          expectedPersonQueryParameters: const <String, String>{},
          personResponseJson: '{"id": "a", "dynamicName": "Aagje"}',
          avatarPath: 'tas/api/avatars/operator/',
          personIds: <String>{'a'},
        );

        final co = await atp.currentIncidentOperator();
        expect(co.id, 'a');
        expect(co.avatar, 'avatarFora');
      });

      test('sanatized starts with', () async {
        final atp = personApiTopdeskProvider(
          personPath: 'tas/api/operators',
          expectedPersonQueryParameters: const <String, String>{
            'lastname': 'a&hourlyRate=50',
          },
          personResponseJson: '[{"id": "a", "dynamicName": "Aagje", '
              '"firstLineCallOperator": true}]',
          avatarPath: 'tas/api/avatars/operator/',
          personIds: <String>{'a'},
        );

        await atp.incidentOperators(
          startsWith: 'a&hourlyRate=50',
        );
      });
    });

    group('incident', () {
      final settings = Settings(
        branchId: 'a',
        callerId: 'a',
        categoryId: 'a',
        subCategoryId: 'a',
        incidentDurationId: 'a',
        incidentOperatorId: 'a',
      );

      test('create without request', () async {
        final Client client = MockClient((Request request) async {
          expect(request.url.path, credentials.url + '/tas/api/incidents');
          expect(
            request.headers[HttpHeaders.contentTypeHeader],
            'application/json; charset=utf-8',
          );

          final body = json.decode(request.body);
          expect(body['status'], 'firstLine');
          expect(body['briefDescription'], 'my "todo"');
          expect(body.containsKey('request'), isFalse);
          expect(body['callerBranch'], {'id': 'a'});
          expect(body['caller'], {'id': 'a'});
          expect(body['category'], {'id': 'a'});
          expect(body['subcategory'], {'id': 'a'});
          expect(body['duration'], {'id': 'a'});
          expect(body['operator'], {'id': 'a'});

          return Response(
            '{"number": "19 12 002"}',
            201,
          );
        });

        final p = ApiTopdeskProvider()
          ..init(
            credentials,
            client: client,
          );
        final number = await p.createIncident(
          briefDescription: 'my "todo"',
          settings: settings,
        );

        expect(number, '19 12 002');
      });

      test('create with request', () async {
        final Client client = MockClient((Request request) async {
          expect(request.url.path, credentials.url + '/tas/api/incidents');
          expect(
            request.headers[HttpHeaders.contentTypeHeader],
            'application/json; charset=utf-8',
          );

          final body = json.decode(request.body);
          expect(body['status'], 'firstLine');
          expect(body['briefDescription'], 'my "todo"');
          expect(body['request'], 'my request');
          expect(body['callerBranch'], {'id': 'a'});
          expect(body['caller'], {'id': 'a'});
          expect(body['category'], {'id': 'a'});
          expect(body['subcategory'], {'id': 'a'});
          expect(body['duration'], {'id': 'a'});
          expect(body['operator'], {'id': 'a'});

          return Response(
            '{"number": "19 12 002"}',
            201,
          );
        });

        final p = ApiTopdeskProvider()
          ..init(
            credentials,
            client: client,
          );
        final number = await p.createIncident(
          briefDescription: 'my "todo"',
          request: 'my request',
          settings: settings,
        );

        expect(number, '19 12 002');
      });
    });
  });
}
