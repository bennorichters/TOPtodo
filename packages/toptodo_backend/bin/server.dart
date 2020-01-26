import 'dart:io';
import 'package:appengine/appengine.dart';
import 'package:toptodo_topdesk_provider_mock/toptodo_topdesk_provider_mock.dart';

void main() async {
  await runAppEngine(requestHandler);
}

void requestHandler(HttpRequest request) async {
  if (request.method == 'HEAD') {
    request.response..statusCode = 200;
  } else if (request.method == 'GET') {
    await respondToGet(request);
  } else if (request.method == 'POST') {
    respondToPost(request);
  } else {
    request.response..statusCode = 405;
  }
  await request.response.close();
}

void respondToGet(HttpRequest request) async {
  final path = request.uri.path;
  if (path == '/') {
    request.response..write('TOPtodo');
  } else if (path.startsWith('/tas/api/branches/id/')) {
    final prov = FakeTopdeskProvider(latency: Duration.zero);
    final id = path.substring('/tas/api/branches/id/'.length);
    try {
      final branch = await prov.tdBranch(id: id);
      request.response.headers.add(
        HttpHeaders.contentTypeHeader,
        'application/json;charset=utf-8',
      );
      request.response.write(
        '{"id": "${branch.id}", '
        '"name": "${branch.name}"}',
      );
    } catch (error) {
      request.response.statusCode = 404;
    }
  } else {
    request.response.statusCode = 404;
  }
}

void respondToPost(HttpRequest request) {}
