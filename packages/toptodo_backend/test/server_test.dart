import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mock_request/mock_request.dart';
import 'package:test/test.dart';
import 'package:toptodo_data/toptodo_data.dart';
import 'package:toptodo_topdesk_provider_api/toptodo_topdesk_provider_api.dart';

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

    final tdProvider = ApiTopdeskProvider();

    setUp(() async {
      await tdProvider.init(credentials, client: client);
    });

    tearDown(() {
      tdProvider.dispose();
    });

    test('version', () async {
      expect(await tdProvider.apiVersion(), '3.1.0');
    });

    test('current operator', () async {
      final currentOperator = await tdProvider.currentTdOperator();
      expect(currentOperator.name, 'Dawn Meadows');
    });
  });
}
