import 'dart:convert';
import 'dart:io';

import 'package:toptodo_data/toptodo_data.dart';

const pathTasApiPrefix = '/tas/api/';

void respondToGet(HttpRequest request, TopdeskProvider tdProvider) async {
  Map<String, dynamic> fixPerson(TdPerson person) {
    final jsonMap = person.toJson();
    jsonMap.remove('avatar');
    jsonMap['dynamicName'] = jsonMap['name'];
    return jsonMap;
  }

  Map<String, dynamic> getAvatar(TdPerson person) => {
        'image': person.toJson()['avatar'],
      };

  final pathPlain = {
    'version': () async => {'version': await tdProvider.apiVersion()},
    'operators/current': () async =>
        fixPerson(await tdProvider.currentTdOperator()),
  };

  final pathById = {
    'branches/id': (String id) async =>
        (await tdProvider.tdBranch(id: id)).toJson(),
    'persons/id': (String id) async =>
        fixPerson(await tdProvider.tdCaller(id: id)),
    'operators/id': (String id) async => fixPerson(
          await tdProvider.tdOperator(id: id),
        ),
    'avatars/person': (String id) async => getAvatar(
          await tdProvider.tdCaller(id: id),
        ),
    'avatars/operator': (String id) async => getAvatar(
          await tdProvider.tdOperator(id: id),
        ),
  };

  final pathSearch = {
    'branches': {
      'parameter': 'nameFragment',
      'hasAvatar': false,
      'call': (String search) async => tdProvider.tdBranches(
            startsWith: search,
          ),
    },
    'persons': {
      'parameter': 'lastname',
      'hasAvatar': true,
      'call': (String search) async {
        final allBranches = await tdProvider.tdBranches(startsWith: '');
        final result = <TdCaller>[];
        for (final branch in allBranches) {
          final callers = await tdProvider.tdCallers(
            tdBranch: branch,
            startsWith: search,
          );
          result.addAll(callers);
        }

        return result..sort((c1, c2) => c1.name.compareTo(c2.name));
      }
    },
    'operators': {
      'parameter': 'lastname',
      'hasAvatar': true,
      'call': (String search) async => tdProvider.tdOperators(
            startsWith: search,
          ),
    },
  };

  final pathList = {
    'categories': () async => await tdProvider.tdCategories(),
    'durations': () async => await tdProvider.tdDurations(),
    'subcategories': () async {
      final cats = await tdProvider.tdCategories();
      final result = [];
      for (final cat in cats) {
        result.addAll(await tdProvider.tdSubcategories(tdCategory: cat));
      }

      return result..sort((s1, s2) => s1.id.compareTo(s2.id));
    },
  };

  Future<dynamic> respondToPathPlain(String path) async {
    final key = pathPlain.keys.firstWhere(
      (key) => key == path,
      orElse: () => null,
    );
    return key == null ? null : await pathPlain[key]();
  }

  Future<dynamic> respondToPathById(String path) async {
    final key = pathById.keys.firstWhere(
      (key) => RegExp('^$key/[^/]+\$').hasMatch(path),
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

  Future<dynamic> respondToPathSearch(
    String path,
  ) async {
    final key = pathSearch.keys.firstWhere(
      (key) => key == path,
      orElse: () => null,
    );

    if (key == null) {
      return null;
    }

    final paramKey = pathSearch[key]['parameter'];
    if (!request.uri.queryParameters.containsKey(paramKey)) {
      return null;
    }

    final Function call = pathSearch[key]['call'];
    Iterable<TdModel> models =
        await call(request.uri.queryParameters[paramKey]);

    return pathSearch[key]['hasAvatar']
        ? models.map((m) => fixPerson(m)).toList()
        : List.from(models);
  }

  Future<dynamic> respondToPathList(
    String path,
  ) async {
    final key = pathList.keys.firstWhere(
      (key) => 'incidents/' + key == path,
      orElse: () => null,
    );
    final call = pathList[key];
    return key == null ? null : List.from(await call());
  }

  final requestPath = request.uri.path;
  if (requestPath == '/') {
    request.response..write('TOPtodo');
  } else if (requestPath.startsWith(pathTasApiPrefix)) {
    request.response.headers
        .add(HttpHeaders.contentTypeHeader, 'application/json');

    final path = requestPath.substring(pathTasApiPrefix.length);

    var jsonResult = await respondToPathPlain(path);
    jsonResult = jsonResult ?? await respondToPathById(path);
    jsonResult = jsonResult ?? await respondToPathSearch(path);
    jsonResult = jsonResult ?? await respondToPathList(path);

    if (jsonResult == null) {
      request.response.statusCode = 404;
    } else {
      request.response.statusCode = 200;
      request.response.write(json.encode(jsonResult));
    }
  } else {
    request.response.statusCode = 404;
  }
}
