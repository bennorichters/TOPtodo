import 'dart:io';

import 'package:toptodo_topdesk_provider_mock/'
    'toptodo_topdesk_provider_mock.dart';

import 'api_get.dart';
import 'api_post.dart';

final _tdProvider = FakeTopdeskProvider(latency: Duration.zero);

/// Processes all TOPdesk API http requests that are used by TOPtodo.
///
/// The response to requests contains test data. This is not a real TOPdesk
/// implementation. Only the subset of the TOPdesk public API that is used by
/// TOPtodo is implemented. All other requests will respond with an error code.
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
