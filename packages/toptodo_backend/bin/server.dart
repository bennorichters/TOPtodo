import 'dart:convert';
import 'dart:io';
import 'package:appengine/appengine.dart';
import 'package:toptodo_data/toptodo_data.dart';
import 'package:toptodo_topdesk_provider_mock/toptodo_topdesk_provider_mock.dart';

const pathTasApiPrefix = '/tas/api/';
TopdeskProvider tdProvider;

void main() async {
  tdProvider = FakeTopdeskProvider(latency: Duration.zero);
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

final pathPlain = {
  'version': () async => {'version': '3.1.0'},
  'operators/current': () async =>
      removeAvatar(await tdProvider.currentTdOperator()),
};

final pathById = {
  'branches': (String id) async => (await tdProvider.tdBranch(id: id)).toJson(),
  'persons': (String id) async =>
      removeAvatar(await tdProvider.tdCaller(id: id)),
  'operators': (String id) async => removeAvatar(
        await tdProvider.tdOperator(id: id),
      ),
  'avatars/persons': (String id) async => getAvatar(
        await tdProvider.tdCaller(id: id),
      ),
  'avatars/operators': (String id) async => getAvatar(
        await tdProvider.tdOperator(id: id),
      ),
};

Map<String, dynamic> removeAvatar(TdPerson person) =>
    person.toJson()..remove('avatar');

Map<String, dynamic> getAvatar(TdPerson person) => {
      'avatar': person.toJson()['avatar'],
    };

void respondToGet(HttpRequest request) async {
  final requestPath = request.uri.path;
  if (requestPath == '/') {
    request.response..write('TOPtodo');
  } else if (requestPath.startsWith(pathTasApiPrefix)) {
    request.response.headers
        .add(HttpHeaders.contentTypeHeader, 'application/json');

    final path = requestPath.substring(pathTasApiPrefix.length);

    var jsonMap = await respondToPathPlain(path);
    jsonMap = jsonMap ?? await respondToPathById(path);

    if (jsonMap == null) {
      request.response.statusCode = 404;
    } else {
      request.response.statusCode = 200;
      request.response.write(json.encode(jsonMap));
    }
  } else {
    request.response.statusCode = 404;
  }
}

Future<Map<String, dynamic>> respondToPathPlain(String path) async {
  final key = pathPlain.keys.firstWhere(
    (key) => key == path,
    orElse: () => null,
  );
  return key == null ? null : await pathPlain[key]();
}

Future<Map<String, dynamic>> respondToPathById(String path) async {
  final key = pathById.keys.firstWhere(
    (key) => RegExp('^$key/id/[^/]+\$').hasMatch(path),
    orElse: () => null,
  );

  if (key == null) {
    return null;
  }

  final id = RegExp(r'[^/]+$').firstMatch(path).group(0);
  try {
    return await pathById[key](id);
  } catch (error) {
    return null;
  }
}

void respondToPost(HttpRequest request) {}
