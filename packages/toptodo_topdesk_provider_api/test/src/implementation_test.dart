import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:toptodo_data/toptodo_data.dart';
import 'package:toptodo_topdesk_provider_api/toptodo_topdesk_provider_api.dart';

void main() {
  const credentials = Credentials(
    url: 'a',
    loginName: 'userA',
    password: 'S3CrEt!',
  );

  group('errors', () {
    final Client client = MockClient((Request request) async {
      if (request.method == 'HEAD') {
        return Response('', 200);
      }

      throw ArgumentError();
    });

    test('StateError without init', () async {
      final atp = ApiTopdeskProvider();
      expect(atp.tdBranches(startsWith: ''), throwsStateError);
      atp.dispose();
    });

    test('StateError after dispose', () async {
      final atp = ApiTopdeskProvider();
      await atp.init(credentials, client: client);
      atp.dispose();
      expect(atp.tdBranches(startsWith: ''), throwsStateError);
    });

    test('init with 404 url', () async {
      final Client client404 = MockClient((Request request) async {
        if (request.method == 'HEAD') {
          return Response('', 404);
        }

        throw ArgumentError();
      });

      final atp = ApiTopdeskProvider();
      expect(
        () async => await atp.init(
          credentials,
          client: client404,
        ),
        throwsA(const TypeMatcher<TdCannotConnect>()),
      );
    });

    test('init client.get throws error', () async {
      final Client clientError = MockClient((Request request) async {
        throw ArgumentError();
      });

      final atp = ApiTopdeskProvider();
      expect(
        () async => await atp.init(
          credentials,
          client: clientError,
        ),
        throwsA(const TypeMatcher<TdCannotConnect>()),
      );
    });

    test('call init twice throws', () async {
      final atp = ApiTopdeskProvider();
      await atp.init(credentials, client: client);

      expect(
        () async => await atp.init(
          credentials,
          client: client,
        ),
        throwsStateError,
      );
      atp.dispose();
    });

    Future<void> testErrorCode(int code, TypeMatcher<dynamic> tm) async {
      final Client client = MockClient((Request request) async {
        if (request.method == 'HEAD') {
          return Response('', 200);
        }

        return Response('', code);
      });

      final atp = ApiTopdeskProvider();

      await atp.init(
        credentials,
        client: client,
      );

      expect(
        atp.tdBranch(id: 'xyz'),
        throwsA(tm),
      );
      atp.dispose();
    }

    test('400', () async {
      await testErrorCode(400, const TypeMatcher<TdBadRequestException>());
    });

    test('401', () async {
      await testErrorCode(401, const TypeMatcher<TdNotAuthorizedException>());
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

    test('client throws some error', () async {
      final Client client = MockClient((Request request) async {
        if (request.method == 'HEAD') {
          return Response('', 200);
        }

        throw StateError('just testing');
      });

      final atp = ApiTopdeskProvider();
      await atp.init(
        credentials,
        client: client,
      );

      expect(
        atp.tdBranch(id: 'xyz'),
        throwsA(
          const TypeMatcher<TdServerException>(),
        ),
      );

      atp.dispose();
    });

    test('client throws SocketException', () async {
      final Client client = MockClient((Request request) async {
        if (request.method == 'HEAD') {
          return Response('', 200);
        }

        throw SocketException('just testing');
      });

      final atp = ApiTopdeskProvider();
      await atp.init(
        credentials,
        client: client,
      );

      expect(
        atp.tdBranch(id: 'xyz'),
        throwsA(
          const TypeMatcher<TdCannotConnect>(),
        ),
      );

      atp.dispose();
    });

    test('timeout', () async {
      final Client client = MockClient((Request request) async {
        if (request.method == 'HEAD') {
          return Response('', 200);
        }

        return Future<Response>.delayed(
          const Duration(milliseconds: 50),
          () => Response('{"id": "a", "name": "ABA"}', 200),
        );
      });

      final atp = ApiTopdeskProvider(
        timeOut: const Duration(milliseconds: 10),
      );
      await atp.init(
        credentials,
        client: client,
      );

      expect(
        atp.tdBranch(id: 'a'),
        throwsA(
          const TypeMatcher<TdTimeOutException>(),
        ),
      );

      atp.dispose();
    });
  });

  group('special', () {
    test('no entities found', () async {
      final Client client = MockClient((Request request) async {
        if (request.method == 'HEAD') {
          return Response('', 200);
        }

        return Response(
          '{"message": "No entitites found"}',
          204,
        );
      });

      final atp = ApiTopdeskProvider();
      await atp.init(
        credentials,
        client: client,
      );

      final branches = await atp.tdBranches(startsWith: 'xyz');
      expect(branches.length, isZero);

      atp.dispose();
    });
  });

  group('meta', () {
    test('headers', () async {
      Map<String, String> headers;
      final mc = MockClient((Request req) async {
        if (req.method == 'HEAD') {
          return Response('', 200);
        }

        headers = req.headers;
        return Response('[]', 200);
      });

      final atp = ApiTopdeskProvider();
      await atp.init(credentials, client: mc);
      await atp.tdDurations();

      expect(headers['accept'], 'application/json');

      expect(headers['authorization'].startsWith('Basic '), isTrue);
      final decoded = utf8
          .fuse(base64)
          .decode(headers['authorization'].substring('Basic '.length));
      expect(decoded, credentials.loginName + ':' + credentials.password);

      atp.dispose();
    });
  });

  group('api call', () {
    ApiTopdeskProvider basicProvider;
    ApiTopdeskProvider personProvider;

    const defaultJson = '[{"id": "a", "name": "ABA"},'
        '{"id": "b", "name": "DEF"},'
        '{"id": "c", "name": "ABB"}]';

    Future<void> basicApiTopdeskProvider({
      String expectedPath,
      Map<String, String> expectedQueryParameters,
      int responseCode,
      String responseJson,
    }) async {
      final Client client = MockClient((Request request) async {
        if (request.method == 'HEAD') {
          return Response('', 200);
        }

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

      basicProvider = ApiTopdeskProvider();
      await basicProvider.init(
        credentials,
        client: client,
      );
    }

    Future<void> personApiTopdeskProvider({
      String personPath,
      Map<String, String> expectedPersonQueryParameters,
      String personResponseJson,
      int responseCode = 200,
      String avatarPath,
      Set<String> personIds,
    }) async {
      final Client client = MockClient((Request req) async {
        if (req.method == 'HEAD') {
          return Response('', 200);
        }

        final path = req.url.path.substring(
          credentials.url.length + 1,
        );
        if (path == personPath) {
          expect(
            req.url.queryParameters,
            expectedPersonQueryParameters,
          );
          return Response(personResponseJson, responseCode);
        } else if (path.startsWith(avatarPath)) {
          final id = path.substring(avatarPath.length);
          expect(
            personIds.contains(id),
            isTrue,
            reason: 'unexpected request for avatar with caller id $id',
          );

          return Response('{"image": "avatarFor$id"}', responseCode);
        } else {
          fail('unexpected call to endpoint: $path');
        }
      });

      personProvider = ApiTopdeskProvider();
      await personProvider.init(
        credentials,
        client: client,
      );
    }

    tearDown(() {
      basicProvider?.dispose();
      basicProvider = null;

      personProvider?.dispose();
      personProvider = null;
    });

    group('branch', () {
      test('find by id', () async {
        await basicApiTopdeskProvider(
          expectedPath: 'tas/api/branches/id/a',
          responseJson: '{"id": "a", "name": "ABA"}',
        );
        final b = await basicProvider.tdBranch(id: 'a');

        expect(b.id, 'a');
      });

      test('find by nonexisting id throws', () async {
        await basicApiTopdeskProvider(
          responseCode: 404,
          responseJson: '',
        );
        expect(
          basicProvider.tdBranch(id: 'doesnotexist'),
          throwsA(
            const TypeMatcher<TdModelNotFoundException>(),
          ),
        );
      });

      test('starts with find two', () async {
        await basicApiTopdeskProvider(
          expectedPath: 'tas/api/branches',
          expectedQueryParameters: <String, String>{
            '\$fields': 'id,name',
            'nameFragment': 'ab',
          },
          responseJson: '[{"id": "a", "name": "ABA"},'
              '{"id": "c", "name": "ABB"}]',
        );

        final bs = await basicProvider.tdBranches(startsWith: 'ab');
        expect(bs.length, 2);
      });

      test('sanatized starts with', () async {
        await basicApiTopdeskProvider(
          expectedPath: 'tas/api/branches',
          expectedQueryParameters: <String, String>{
            '\$fields': 'id,name',
            'nameFragment': 'a&hourlyRate=50',
          },
          responseJson: '[{"id": "a", "name": "ABA"},'
              '{"id": "c", "name": "ABB"}]',
        );

        await basicProvider.tdBranches(
          startsWith: 'a&hourlyRate=50',
        );
      });
    });

    group('caller', () {
      const branchForCaller = TdBranch(
        id: 'a',
        name: 'branchA',
      );

      test('find by id', () async {
        await personApiTopdeskProvider(
          personPath: 'tas/api/persons/id/aa',
          expectedPersonQueryParameters: <String, String>{
            '\$fields': 'id,dynamicName,branch',
          },
          personResponseJson: '{"id": "aa", "dynamicName": "Augustin Sheryll",'
              ' "branch": {"id": "a", "name": "branchA"}}',
          avatarPath: 'tas/api/avatars/person/',
          personIds: <String>{'aa'},
        );

        final c = await personProvider.tdCaller(id: 'aa');

        expect(c.id, 'aa');
        expect(c.avatar, 'avatarForaa');
      });

      test('find by nonexisting id throws', () async {
        await basicApiTopdeskProvider(
          responseCode: 404,
          responseJson: '',
        );
        expect(
          basicProvider.tdCaller(id: 'doesnotexist'),
          throwsA(
            const TypeMatcher<TdModelNotFoundException>(),
          ),
        );
      });

      test('starts with find two', () async {
        await personApiTopdeskProvider(
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

        final cs = await personProvider.tdCallers(
          tdBranch: branchForCaller,
          startsWith: 'ab',
        );

        expect(cs.length, 2);
        expect(cs.first.id, 'aa');
        expect(cs.first.avatar, 'avatarForaa');
        expect(cs.last.id, 'ac');
        expect(cs.last.avatar, 'avatarForac');
      });

      test('sanatized starts with', () async {
        await personApiTopdeskProvider(
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

        await personProvider.tdCallers(
          tdBranch: branchForCaller,
          startsWith: 'a&hourlyRate=50',
        );
      });
    });

    group('category', () {
      test('find by id', () async {
        await basicApiTopdeskProvider(
          expectedPath: 'tas/api/incidents/categories',
        );
        final c = await basicProvider.tdCategory(id: 'a');

        expect(c.id, 'a');
      });

      test('find by nonexisting id throws', () async {
        await basicApiTopdeskProvider();
        expect(
          basicProvider.tdCategory(id: 'doesnotexist'),
          throwsA(
            const TypeMatcher<TdModelNotFoundException>(),
          ),
        );
      });

      test('find three', () async {
        await basicApiTopdeskProvider(
          expectedPath: 'tas/api/incidents/categories',
        );
        final cs = await basicProvider.tdCategories();

        expect(cs.length, 3);
        expect(cs.first.id, 'a');
      });
    });

    group('subcategory', () {
      const subcategoryJson = '[{'
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
        await basicApiTopdeskProvider(
          expectedPath: 'tas/api/incidents/subcategories',
          responseJson: subcategoryJson,
        );

        final sc = await basicProvider.tdSubcategory(id: 'ab');
        expect(sc.id, 'ab');
      });

      test('find by non existing id throws', () async {
        await basicApiTopdeskProvider(
          responseJson: subcategoryJson,
        );

        expect(
          basicProvider.tdSubcategory(id: 'doesnotexist'),
          throwsA(
            const TypeMatcher<TdModelNotFoundException>(),
          ),
        );
      });

      test('find by category', () async {
        await basicApiTopdeskProvider(
          expectedPath: 'tas/api/incidents/subcategories',
          responseJson: subcategoryJson,
        );

        const cat = TdCategory(
          id: 'a',
          name: 'catA',
        );

        final subcats = await basicProvider.tdSubcategories(
          tdCategory: cat,
        );
        expect(subcats.length, 2);
        expect(subcats.first.id, 'aa');
        expect(subcats.last.id, 'ac');
      });
    });

    group('duration', () {
      test('find by id', () async {
        await basicApiTopdeskProvider(
          expectedPath: 'tas/api/incidents/durations',
        );
        final id = await basicProvider.tdDuration(id: 'a');

        expect(id.id, 'a');
      });

      test('find by nonexisting id throws', () async {
        await basicApiTopdeskProvider();
        expect(
          basicProvider.tdDuration(id: 'doesnotexist'),
          throwsA(
            const TypeMatcher<TdModelNotFoundException>(),
          ),
        );
      });

      test('find three', () async {
        await basicApiTopdeskProvider(
          expectedPath: 'tas/api/incidents/durations',
        );
        final ids = await basicProvider.tdDurations();

        expect(ids.length, 3);
        expect(ids.first.id, 'a');
      });
    });

    group('operator', () {
      test('find by id', () async {
        await personApiTopdeskProvider(
          personPath: 'tas/api/operators/id/a',
          expectedPersonQueryParameters: <String, String>{},
          personResponseJson: '{'
              '"id": "a", '
              '"dynamicName": "Augustin Sheryll", '
              '"firstLineCallOperator": true, '
              '"secondLineCallOperator": true'
              '}',
          avatarPath: 'tas/api/avatars/operator/',
          personIds: <String>{'a'},
        );

        final op = await personProvider.tdOperator(id: 'a');

        expect(op.id, 'a');
        expect(op.avatar, 'avatarFora');
      });

      test('find by non existing id throws', () async {
        await basicApiTopdeskProvider(
          responseCode: 404,
          responseJson: '',
        );
        expect(
          basicProvider.tdOperator(id: 'doesnotexist'),
          throwsA(
            const TypeMatcher<TdModelNotFoundException>(),
          ),
        );
      });

      test('find by starts with', () async {
        await personApiTopdeskProvider(
          personPath: 'tas/api/operators',
          expectedPersonQueryParameters: const <String, String>{
            'lastname': 'a',
          },
          personResponseJson: '['
              '{'
              '"id": "a", "dynamicName": "Aagje", '
              '"firstLineCallOperator": true, '
              '"secondLineCallOperator": true'
              '},'
              '{'
              '"id": "b", "dynamicName": "Ad", '
              '"firstLineCallOperator": false, '
              '"secondLineCallOperator": false'
              '},'
              '{'
              '"id": "c", "dynamicName": "Albert", '
              '"firstLineCallOperator": true, '
              '"secondLineCallOperator": false'
              '}'
              ']',
          avatarPath: 'tas/api/avatars/operator/',
          personIds: <String>{'a', 'c'},
        );

        final os = await personProvider.tdOperators(startsWith: 'a');

        expect(os.length, 2);
        expect(os.first.id, 'a');
        expect(os.first.avatar, 'avatarFora');
        expect(os.last.id, 'c');
        expect(os.last.avatar, 'avatarForc');
      });

      test('current', () async {
        await personApiTopdeskProvider(
          personPath: 'tas/api/operators/current',
          expectedPersonQueryParameters: const <String, String>{},
          personResponseJson: '{'
              '"id": "a", '
              '"dynamicName": "Aagje", '
              '"firstLineCallOperator": true, '
              '"secondLineCallOperator": true'
              '}',
          avatarPath: 'tas/api/avatars/operator/',
          personIds: <String>{'a'},
        );

        final co = await personProvider.currentTdOperator();
        expect(co.id, 'a');
        expect(co.avatar, 'avatarFora');
      });

      test('current cached', () async {
        const res1 = '{'
            '"id": "a", '
            '"dynamicName": "Aagje", '
            '"firstLineCallOperator": true, '
            '"secondLineCallOperator": true'
            '}';
        const res2 = '{'
            '"id": "b", '
            '"dynamicName": "Beatrijs", '
            '"firstLineCallOperator": true, '
            '"secondLineCallOperator": true'
            '}';

        var flag = false;

        final Client client = MockClient((Request req) async {
          if (req.method == 'HEAD') {
            return Response('', 200);
          }

          if (req.url.path.contains('avatar')) {
            return Response('{"image": "avatar"}', 200);
          }

          final res = Response(
            flag ? res2 : res1,
            200,
          );
          flag = true;
          return res;
        });

        final atp = ApiTopdeskProvider();
        await atp.init(
          credentials,
          client: client,
        );

        expect((await atp.currentTdOperator()).id, 'a');
        expect((await atp.currentTdOperator()).id, 'a');

        atp.dispose();
      });

      test('current cached expired', () async {
        const res1 = '{'
            '"id": "a", '
            '"dynamicName": "Aagje", '
            '"firstLineCallOperator": true, '
            '"secondLineCallOperator": true'
            '}';
        const res2 = '{'
            '"id": "b", '
            '"dynamicName": "Beatrijs", '
            '"firstLineCallOperator": true, '
            '"secondLineCallOperator": true'
            '}';
        var flag = false;

        final Client client = MockClient((Request req) async {
          if (req.method == 'HEAD') {
            return Response('', 200);
          }

          if (req.url.path.contains('avatar')) {
            return Response('{"image": "avatar"}', 200);
          }

          final res = Response(
            flag ? res2 : res1,
            200,
          );
          flag = true;

          return res;
        });

        final atp = ApiTopdeskProvider(
          currentOperatorCacheDuration: Duration.zero,
        );
        await atp.init(
          credentials,
          client: client,
        );

        expect((await atp.currentTdOperator()).id, 'a');
        await Future.delayed(const Duration(milliseconds: 1));
        expect((await atp.currentTdOperator()).id, 'b');

        atp.dispose();
      });

      test('sanatized starts with', () async {
        await personApiTopdeskProvider(
          personPath: 'tas/api/operators',
          expectedPersonQueryParameters: const <String, String>{
            'lastname': 'a&hourlyRate=50',
          },
          personResponseJson: '[{"id": "a", "dynamicName": "Aagje", '
              '"firstLineCallOperator": true}]',
          avatarPath: 'tas/api/avatars/operator/',
          personIds: <String>{'a'},
        );

        await personProvider.tdOperators(
          startsWith: 'a&hourlyRate=50',
        );
      });
    });

    group('create incident', () {
      final settings = Settings(
        tdBranchId: 'a',
        tdCallerId: 'a',
        tdCategoryId: 'a',
        tdSubcategoryId: 'a',
        tdDurationId: 'a',
        tdOperatorId: 'a',
      );

      test('without request', () async {
        final Client client = MockClient((Request request) async {
          if (request.method == 'HEAD') {
            return Response('', 200);
          }

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

        final p = ApiTopdeskProvider();
        await p.init(
          credentials,
          client: client,
        );
        final number = await p.createTdIncident(
          briefDescription: 'my "todo"',
          settings: settings,
        );

        expect(number, '19 12 002');
        p.dispose();
      });

      test('with request', () async {
        final Client client = MockClient((Request request) async {
          if (request.method == 'HEAD') {
            return Response('', 200);
          }

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

        final p = ApiTopdeskProvider();
        await p.init(
          credentials,
          client: client,
        );
        final number = await p.createTdIncident(
          briefDescription: 'my "todo"',
          request: 'my request',
          settings: settings,
        );

        expect(number, '19 12 002');
        p.dispose();
      });

      test('with request with new lines', () async {
        final Client client = MockClient((Request request) async {
          if (request.method == 'HEAD') {
            return Response('', 200);
          }

          final body = json.decode(request.body);
          expect(
            body['request'],
            'my request<br>with<br>several<br>new lines',
          );

          return Response('{"number": "1"}', 201);
        });

        final p = ApiTopdeskProvider();
        await p.init(
          credentials,
          client: client,
        );
        await p.createTdIncident(
          briefDescription: 'new line test',
          request: 'my request\nwith\nseveral\nnew lines',
          settings: settings,
        );
        p.dispose();
      });
    });
  });
}
