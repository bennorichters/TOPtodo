import 'dart:io';
import 'package:appengine/appengine.dart';
import 'package:toptodo_data/toptodo_data.dart';
import 'package:toptodo_topdesk_provider_mock/toptodo_topdesk_provider_mock.dart';

import 'api_get.dart';

TopdeskProvider tdProvider;

void main() async {
  tdProvider = FakeTopdeskProvider(latency: Duration.zero);
  await runAppEngine(requestHandler);
}

void requestHandler(HttpRequest request) async {
  if (request.method == 'HEAD') {
    request.response..statusCode = 200;
  } else if (request.method == 'GET') {
    await respondToGet(request, tdProvider);
  } else if (request.method == 'POST') {
    respondToPost(request);
  } else {
    request.response..statusCode = 405;
  }
  await request.response.close();
}

void respondToPost(HttpRequest request) {}
