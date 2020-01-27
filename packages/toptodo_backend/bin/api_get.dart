import 'dart:convert';
import 'dart:io';

import 'package:toptodo_data/toptodo_data.dart';

const pathTasApiPrefix = '/tas/api/';

void respondToGet(HttpRequest request, TopdeskProvider tdProvider) async {
  Map<String, dynamic> removeAvatar(TdPerson person) =>
      person.toJson()..remove('avatar');

  Map<String, dynamic> getAvatar(TdPerson person) => {
        'avatar': person.toJson()['avatar'],
      };

  final pathPlain = {
    'version': () async => {'version': '3.1.0'},
    'operators/current': () async =>
        removeAvatar(await tdProvider.currentTdOperator()),
  };

  final pathById = {
    'branches': (String id) async =>
        (await tdProvider.tdBranch(id: id)).toJson(),
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
