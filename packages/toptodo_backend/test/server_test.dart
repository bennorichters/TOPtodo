import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mock_request/mock_request.dart';
import 'package:test/test.dart';
import 'package:toptodo_data/toptodo_data.dart';
import 'package:toptodo_topdesk_provider_api/toptodo_topdesk_provider_api.dart';
import 'package:toptodo_topdesk_provider_mock/toptodo_topdesk_provider_mock.dart';

import '../bin/server.dart';

void main() {
  group('requestHandler with ApiTopdeskProvider', () {
    final client = MockClient((Request request) async {
      final mockHttpRequest = MockHttpRequest(request.method, request.url);

      requestHandler(mockHttpRequest);

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

    final apiTdProvider = ApiTopdeskProvider();
    final fakeTdProvider = FakeTopdeskProvider(latency: Duration.zero);

    setUp(() async {
      await apiTdProvider.init(credentials, client: client);
    });

    tearDown(() {
      apiTdProvider.dispose();
    });

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

    test('current operator', () async {
      expect(
        await apiTdProvider.currentTdOperator(),
        await fakeTdProvider.currentTdOperator(),
      );
    });
  });
}
