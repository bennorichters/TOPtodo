import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mock_request/mock_request.dart';
import 'package:test/test.dart';

import 'package:toptodo_backend/toptodo_backend.dart';
import 'package:toptodo_data/toptodo_data.dart';
import 'package:toptodo_topdesk_api/toptodo_topdesk_api.dart';
import 'package:toptodo_topdesk_test_data/toptodo_topdesk_test_data.dart';

void main() {
  group('requestHandler with ApiTopdeskProvider', () {
    final client = MockClient((Request request) async {
      final mockHttpRequest = MockHttpRequest(request.method, request.url);

      await requestHandler(mockHttpRequest);

      final response = mockHttpRequest.response;
      final body = await response.transform(utf8.decoder).join();
      final statusCode = mockHttpRequest.response.statusCode;

      return Response(body, statusCode);
    });

    final credentials = Credentials(
      url: 'https://your-enironment.topdesk.net',
      loginName: 'name',
      password: 'secret',
    );

    var apiTopdeskProvider = ApiTopdeskProvider();
    final apiTdProvider = apiTopdeskProvider;
    final fakeTdProvider = FakeTopdeskProvider(latency: Duration.zero);

    setUp(() async {
      await apiTdProvider.init(credentials, client: client);
    });

    tearDown(() {
      apiTdProvider.dispose();
    });

    group('get', () {
      test('version', () async {
        expect(
          await apiTdProvider.apiVersion(),
          await fakeTdProvider.apiVersion(),
        );
      });

      test('branch by id', () async {
        expect(
          await apiTdProvider.tdBranch(id: 'a'),
          await fakeTdProvider.tdBranch(id: 'a'),
        );
      });

      test('all branches', () async {
        expect(
          await apiTdProvider.tdBranches(startsWith: ''),
          await fakeTdProvider.tdBranches(startsWith: ''),
        );
      });

      test('branches startswith TOP', () async {
        expect(
          await apiTdProvider.tdBranches(startsWith: 'TOP'),
          await fakeTdProvider.tdBranches(startsWith: 'TOP'),
        );
      });

      test('caller by id', () async {
        expect(
          await apiTdProvider.tdCaller(id: 'aa'),
          await fakeTdProvider.tdCaller(id: 'aa'),
        );
      });

      test('all callers from branch a for now returns all callers', () async {
        final branchA = await apiTdProvider.tdBranch(id: 'a');
        final allCallers = await apiTdProvider.tdCallers(
          tdBranch: branchA,
          startsWith: '',
        );
        final callersBranchA = await fakeTdProvider.tdCallers(
          tdBranch: branchA,
          startsWith: '',
        );

        expect(
          callersBranchA.every((c) => allCallers.contains(c)),
          isTrue,
        );
      });

      test('category by id', () async {
        expect(
          await apiTdProvider.tdCategory(id: 'a'),
          await fakeTdProvider.tdCategory(id: 'a'),
        );
      });

      test('all categories', () async {
        expect(
          await apiTdProvider.tdCategories(),
          await fakeTdProvider.tdCategories(),
        );
      });

      test('subcategory by id', () async {
        expect(
          await apiTdProvider.tdSubcategory(id: 'aa'),
          await fakeTdProvider.tdSubcategory(id: 'aa'),
        );
      });

      test('all subcategories', () async {
        final cat = await apiTdProvider.tdCategory(id: 'a');
        expect(
          await apiTdProvider.tdSubcategories(tdCategory: cat),
          await fakeTdProvider.tdSubcategories(tdCategory: cat),
        );
      });

      test('duration by id', () async {
        expect(
          await apiTdProvider.tdDuration(id: 'a'),
          await fakeTdProvider.tdDuration(id: 'a'),
        );
      });

      test('all durations', () async {
        expect(
          await apiTdProvider.tdDurations(),
          await fakeTdProvider.tdDurations(),
        );
      });

      test('operator by id', () async {
        expect(
          await apiTdProvider.tdOperator(id: 'a'),
          await fakeTdProvider.tdOperator(id: 'a'),
        );
      });

      test('all operators', () async {
        expect(
          await apiTdProvider.tdOperators(startsWith: ''),
          await fakeTdProvider.tdOperators(startsWith: ''),
        );
      });

      test('current operator', () async {
        expect(
          await apiTdProvider.currentTdOperator(),
          await fakeTdProvider.currentTdOperator(),
        );
      });
    });

    group('post', () {
      test('create incident', () async {
        final settings = Settings(
          tdBranchId: 'a',
          tdCallerId: 'aa',
          tdCategoryId: 'a',
          tdSubcategoryId: 'aa',
          tdDurationId: 'a',
          tdOperatorId: 'a',
        );
        final nr = await apiTdProvider.createTdIncident(
          settings: settings,
          briefDescription: '',
        );

        expect(nr, isNotEmpty);
      });
    });
  });

  group('errors', () {
    test('unsupported method', () async {
      final mockHttpRequest = MockHttpRequest(
        'PUT',
        Uri.http('test.com', '/'),
      );

      await requestHandler(mockHttpRequest);
      expect(mockHttpRequest.response.statusCode, 405);
    });

    test('404 get tas/api', () async {
      final mockHttpRequest = MockHttpRequest(
        'GET',
        Uri.http('test.com', '/tas/api/doesnotexist'),
      );

      await requestHandler(mockHttpRequest);
      expect(mockHttpRequest.response.statusCode, 404);
    });

    test('404 get different', () async {
      final mockHttpRequest = MockHttpRequest(
        'GET',
        Uri.http('test.com', '/doesnotexist'),
      );

      await requestHandler(mockHttpRequest);
      expect(mockHttpRequest.response.statusCode, 404);
    });

    test('404 post', () async {
      final mockHttpRequest = MockHttpRequest(
        'POST',
        Uri.http('test.com', 'doesnotexist'),
      );

      await requestHandler(mockHttpRequest);
      expect(mockHttpRequest.response.statusCode, 404);
    });
  });

  group('other', () {
    test('root', () async {
      final mockHttpRequest = MockHttpRequest(
        'GET',
        Uri.http('test.com', '/'),
      );

      await requestHandler(mockHttpRequest);
      expect(mockHttpRequest.response.statusCode, 200);
    });
  });
}
