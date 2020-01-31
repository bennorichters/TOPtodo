import 'dart:io';

import 'package:toptodo_topdesk_provider_mock/'
    'toptodo_topdesk_provider_mock.dart';

import 'api_get.dart';
import 'api_post.dart';

final _tdProvider = FakeTopdeskProvider(latency: Duration.zero);

void requestHandler(HttpRequest request) async {
  if (request.method == 'HEAD') {
    request.response..statusCode = 200;
  } else if (request.method == 'GET') {
    await respondToGet(request, _tdProvider);
  } else if (request.method == 'POST') {
    await respondToPost(request, _tdProvider);
  } else {
    request.response..statusCode = 405;
  }
  await request.response.close();
}
