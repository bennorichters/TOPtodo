import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:toptodo_data/toptodo_data.dart';

typedef _HttpMethod = Future<http.Response> Function(String endPoint);

class ApiTopdeskProvider extends TopdeskProvider {
  ApiTopdeskProvider({
    this.timeOut = const Duration(seconds: 30),
    currentOperatorCacheDuration = const Duration(hours: 1),
  }) : _currentOperatorCache = AsyncCache<IncidentOperator>(
          currentOperatorCacheDuration,
        );

  final Duration timeOut;
  final _currentOperatorCache;

  static final _acceptHeaders = {
    HttpHeaders.acceptHeader: 'application/json',
  };

  static final _contentHeaders = {
    HttpHeaders.contentTypeHeader: 'application/json',
  };

  String _url;
  Map<String, String> _getHeaders;
  Map<String, String> _postHeaders;
  http.Client _client;

  static const String _subPathOperator = 'operator';
  static const String _subPathCaller = 'person';

  @override
  void init(Credentials credentials, {http.Client client}) {
    if (_url != null) {
      throw StateError('init has already been called');
    }

    _url = credentials.url;
    _getHeaders = {}
      ..addAll(_createAuthHeaders(credentials))
      ..addAll(_acceptHeaders);

    _postHeaders = {}..addAll(_getHeaders)..addAll(_contentHeaders);

    _client = client ?? http.Client();
  }

  @override
  void dispose() {
    _client?.close();

    _url = null;
    _getHeaders = null;
    _client = null;
  }

  @override
  Future<Branch> branch({String id}) async {
    final dynamic response = await _apiGet('branches/id/$id');
    return _branchFromJson(response);
  }

  @override
  Future<Iterable<Branch>> branches({@required String startsWith}) async {
    final sanitized = _sanatizeUserInput(startsWith);
    final List<dynamic> response =
        await _apiGet('branches?nameFragment=$sanitized&\$fields=id,name');

    return response.map((dynamic e) => _branchFromJson(e));
  }

  static Branch _branchFromJson(Map<String, dynamic> json) => Branch(
        id: json['id'],
        name: json['name'],
      );

  @override
  Future<Caller> caller({String id}) async {
    final dynamic response =
        await _apiGet('persons/id/$id?\$fields=id,dynamicName,branch');

    return _fixCaller(response);
  }

  @override
  Future<Iterable<Caller>> callers({
    @required String startsWith,
    @required Branch branch,
  }) async {
    final sanitized = _sanatizeUserInput(startsWith);
    final List<dynamic> response = await _apiGet(
      'persons?lastname=$sanitized&\$fields=id,dynamicName,branch',
    );

    final fixed = await Future.wait<Caller>(
      response.map(
        (dynamic json) async => await _fixCaller(json),
      ),
    );

    return fixed;
  }

  Future<Caller> _fixCaller(Map<String, dynamic> json) async {
    final dynamic fixed = await _fixPerson(_subPathCaller, json);
    final branch = Branch(
      id: json['branch']['id'],
      name: json['branch']['name'],
    );

    return Caller(
      id: fixed['id'],
      name: fixed['name'],
      avatar: fixed['avatar'],
      branch: branch,
    );
  }

  @override
  Future<Category> category({String id}) async =>
      (await categories()).firstWhere(
        (Category c) => c.id == id,
        orElse: () => throw TdModelNotFoundException('no category for id: $id'),
      );

  @override
  Future<Iterable<Category>> categories() async {
    final List<dynamic> response = await _apiGet('incidents/categories');
    return response.map((dynamic e) => _categoryFromJson(e));
  }

  static Category _categoryFromJson(Map<String, dynamic> json) => Category(
        id: json['id'],
        name: json['name'],
      );

  @override
  Future<SubCategory> subCategory({String id}) async {
    final List<dynamic> response = await _apiGet('incidents/subcategories');
    final dynamic theOne = response.firstWhere(
      (dynamic json) => json['id'] == id,
      orElse: () =>
          throw TdModelNotFoundException('no sub category for id: $id'),
    );

    final category = Category(
      id: theOne['category']['id'],
      name: theOne['category']['name'],
    );
    return _subCategoryFromJson(theOne, category);
  }

  @override
  Future<Iterable<SubCategory>> subCategories({Category category}) async {
    final List<dynamic> response = await _apiGet('incidents/subcategories');

    return response
        .where((dynamic json) => json['category']['id'] == category.id)
        .map((dynamic json) => _subCategoryFromJson(json, category));
  }

  SubCategory _subCategoryFromJson(
    Map<String, dynamic> json,
    Category category,
  ) =>
      SubCategory(
        id: json['id'],
        name: json['name'],
        category: category,
      );

  @override
  Future<IncidentDuration> incidentDuration({String id}) async {
    return (await incidentDurations()).firstWhere(
      (IncidentDuration e) => e.id == id,
      orElse: () =>
          throw TdModelNotFoundException('no incident duration for id: $id'),
    );
  }

  @override
  Future<Iterable<IncidentDuration>> incidentDurations() async {
    final List<dynamic> response = await _apiGet('incidents/durations');
    return response.map((dynamic e) => _incidentDurationFromJson(e));
  }

  static IncidentDuration _incidentDurationFromJson(
    Map<String, dynamic> json,
  ) =>
      IncidentDuration(
        id: json['id'],
        name: json['name'],
      );

  @override
  Future<IncidentOperator> incidentOperator({String id}) async {
    final dynamic response = await _apiGet('operators/id/$id');
    final dynamic fixed = await _fixPerson(_subPathOperator, response);

    return _incidentOperatorFromJson(fixed);
  }

  @override
  Future<IncidentOperator> currentIncidentOperator() async {
    return _currentOperatorCache.fetch(() async {
      final dynamic response = await _apiGet('operators/current');
      final dynamic fixed = await _fixPerson(_subPathOperator, response);

      return _incidentOperatorFromJson(fixed);
    });
  }

  @override
  Future<Iterable<IncidentOperator>> incidentOperators({
    @required String startsWith,
  }) async {
    final sanitized = _sanatizeUserInput(startsWith);
    final List<dynamic> response = await _apiGet(
      'operators?lastname=$sanitized',
    );

    final filtered = response.where(
      (dynamic json) => json['firstLineCallOperator'],
    );

    final fixed = await Future.wait<dynamic>(
      filtered.map(
        (dynamic json) => _fixPerson(_subPathOperator, json),
      ),
    );

    return fixed.map((dynamic json) => _incidentOperatorFromJson(json));
  }

  IncidentOperator _incidentOperatorFromJson(Map<String, dynamic> json) =>
      IncidentOperator(
        id: json['id'],
        name: json['name'],
        avatar: json['avatar'],
      );

  @override
  Future<String> createIncident({
    @required String briefDescription,
    @required Settings settings,
    String request,
  }) async {
    final jsonElements = []
      ..add('"status": "firstLine"')
      ..add('"callerBranch": {"id": "${settings.branchId}"}')
      ..add('"caller": {"id": "${settings.callerId}"}')
      ..add('"category": {"id": "${settings.categoryId}"}')
      ..add('"subcategory": {"id": "${settings.subCategoryId}"}')
      ..add('"duration": {"id": "${settings.incidentDurationId}"}')
      ..add('"operator": {"id": "${settings.incidentOperatorId}"}');

    final escapedDesc = _escapeQuotes(briefDescription);
    jsonElements.add('"briefDescription": "$escapedDesc"');

    if (request != null && request.isNotEmpty) {
      final escapedRequest = _escapeQuotes(request);
      jsonElements.add('"request": "$escapedRequest"');
    }

    final json = '{' + jsonElements.join(',') + '}';

    final response = await _apiPost('incidents', json);
    return response['number'];
  }

  String _escapeQuotes(String userInput) => userInput.replaceAll('"', '\\\"');

  dynamic _apiGet(String endPoint) async => _apiCall(
        endPoint,
        (String endPoint) => _client.get(
          '$_url/tas/api/$endPoint',
          headers: _getHeaders,
        ),
      );

  dynamic _apiPost(String endPoint, String body) async => _apiCall(
        endPoint,
        (String endPoint) => _client.post(
          '$_url/tas/api/$endPoint',
          headers: _postHeaders,
          body: body,
        ),
      );

  dynamic _apiCall(String endPoint, _HttpMethod method) async {
    if (_url == null) {
      throw StateError('call init first');
    }

    http.Response res;
    try {
      res = await method(endPoint).timeout(
        timeOut,
        onTimeout: () => throw TdTimeOutException(
          'time out for: $method',
        ),
      );
    } on TdTimeOutException {
      rethrow;
    } catch (error) {
      throw TdServerException('error get $method error: $error');
    }

    return _processServerResponse(endPoint, res);
  }

  dynamic _processServerResponse(String endPoint, http.Response res) {
    if (res.statusCode == 200 ||
        res.statusCode == 201 ||
        res.statusCode == 206) {
      return json.decode(res.body);
    }

    if (res.statusCode == 204) {
      return json.decode('[]');
    }

    if (res.statusCode == 403) {
      throw TdNotAuthorizedException('403 for $endPoint body: ${res.body}');
    }

    if (res.statusCode == 404) {
      throw TdModelNotFoundException('404 for $endPoint body: ${res.body}');
    }

    if (res.statusCode == 500) {
      throw TdServerException('500 for $endPoint body: ${res.body}');
    }

    throw ArgumentError('endpoint: $endPoint '
        'response status code: ${res.statusCode} '
        'response body: ${res.body}');
  }

  Future<dynamic> _fixPerson(String subPath, dynamic json) async {
    json['name'] = json['dynamicName'];
    json['avatar'] = await _avatarForPerson(subPath, json['id']);
    return json;
  }

  Future<String> _avatarForPerson(String subPath, String id) async {
    final dynamic response = await _apiGet('avatars/$subPath/$id');
    return response['image'];
  }

  String _sanatizeUserInput(String input) => Uri.encodeComponent(input);

  Map<String, String> _createAuthHeaders(Credentials credentials) {
    final encoded = utf8
        .fuse(base64)
        .encode('${credentials.loginName}:${credentials.password}');

    return {
      HttpHeaders.authorizationHeader: 'Basic ' + encoded,
    };
  }
}
