import 'dart:convert';
import 'dart:io';
import 'package:appengine/appengine.dart';
import 'package:toptodo_data/toptodo_data.dart';
import 'package:toptodo_topdesk_provider_mock/toptodo_topdesk_provider_mock.dart';

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
  'version': () => {'version': '3.1.0'},
  'operators/current': () async =>
      (await tdProvider.currentTdOperator()).toJson(),
};

final pathById = {
  'branches/id': (String id) async => await tdProvider.tdBranch(id: id),
  'persons/id': (String id) async => removeAvatar(
        await tdProvider.tdCaller(id: id),
      ),
  'operators/id': (String id) async => removeAvatar(
        await tdProvider.tdOperator(id: id),
      ),
  'avatars/persons/id': (String id) async => getAvatar(
        await tdProvider.tdOperator(id: id),
      ),
  'avatars/operators/id': (String id) async => getAvatar(
        await tdProvider.tdOperator(id: id),
      ),
};

Map<String, dynamic> removeAvatar(TdPerson person) =>
    person.toJson()..remove('avatar');

Map<String, dynamic> getAvatar(TdPerson person) => {
      'avatar': person.toJson()['avatar'],
    };

void respondToGet(HttpRequest request) async {
  final path = request.uri.path;
  if (path == '/') {
    request.response..write('TOPtodo');
  } else if (path.startsWith('/tas/api/branches/id/')) {
    final id = path.substring('/tas/api/branches/id/'.length);
    try {
      final branch = await tdProvider.tdBranch(id: id);
      request.response.headers.add(
        HttpHeaders.contentTypeHeader,
        'application/json;charset=utf-8',
      );
      request.response.write(jsonEncode(branch.toJson()));
    } catch (error) {
      request.response.statusCode = 404;
    }
  } else if (path == '/tas/api/branches') {
    final params = request.uri.queryParameters;
    final search =
        params.containsKey('nameFragment') ? params['nameFragment'] : '';

    final branches = await tdProvider.tdBranches(startsWith: search);
    final result =
        '[' + branches.map((b) => jsonEncode(b.toJson())).join(',') + ']';
    request.response.write(result);
  } else {
    request.response.statusCode = 404;
  }
}

void respondToPost(HttpRequest request) {}
