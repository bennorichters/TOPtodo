import 'dart:io';
import 'package:appengine/appengine.dart';
import 'package:toptodo_topdesk_provider_mock/'
    'toptodo_topdesk_provider_mock.dart';

import 'api_get.dart';

final tdProvider = FakeTopdeskProvider(latency: Duration.zero);

void main() async {
  await runAppEngine(requestHandler);
}

void requestHandler(HttpRequest request) async {
  if (request.method == 'HEAD') {
    request.response..statusCode = 200;
  } else if (request.method == 'GET') {
    await respondToGet(request, tdProvider);
  } else if (request.method == 'POST') {
    await respondToPost(request);
  } else {
    request.response..statusCode = 405;
  }
  await request.response.close();
}

void respondToPost(HttpRequest request) async {
  if (request.uri.path == '/tas/api/incidents') {
    final number = await tdProvider.createTdIncident(
      settings: null,
      briefDescription: '',
    );

    request.response.headers
        .add(HttpHeaders.contentTypeHeader, 'application/json');
    request.response.statusCode = 201;
    request.response.write('{"number": "$number"}');
  } else {
    request.response.statusCode = 404;
  }
}
