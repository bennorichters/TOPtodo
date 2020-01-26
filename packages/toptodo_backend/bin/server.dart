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
  if (request.uri.path == '/') {
    request.response..write('TOPtodo');
  } else {
    final path = request.uri.path.substring(pathTasApiPrefix.length);
    final call = pathPlain.keys.firstWhere((key) => path.startsWith(key));
    // final id = 
  }
}

void respondToPost(HttpRequest request) {}
