import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:toptodo_data/toptodo_data.dart';
import 'package:toptodo_topdesk_provider_api/td_model_cache.dart';

class ApiTopdeskProvider extends TopdeskProvider {
  ApiTopdeskProvider({Duration timeOut})
      : _timeOut = timeOut ?? const Duration(seconds: 5);
  final Duration _timeOut;

  final TdModelCache<Branch> _branchCache = TdModelCache<Branch>();
  final TdModelCache<Caller> _callerCache = TdModelCache<Caller>();

  String _url;
  Map<String, String> _authHeaders;
  http.Client _client;

  static const String _subPathOperator = 'operator';
  static const String _subPathCaller = 'person';

  @override
  void init(Credentials credentials, {http.Client client}) {
    if (_url != null) {
      throw StateError('init has already been called');
    }

    _url = credentials.url;
    _authHeaders = _createAuthHeaders(credentials);
    _client = client ?? http.Client();
  }

  @override
  void dispose() {
    _client?.close();

    _url = null;
    _authHeaders = null;
    _client = null;
  }

  @override
  Future<Branch> branch({String id}) {
    return _branchCache.get(id, (String id) async {
      final dynamic response = await _callApi('branches/id/$id');
      return _branchFromJson(response);
    });
  }

  @override
  Future<Iterable<Branch>> branches({@required String startsWith}) async {
    final String sanitized = _sanatizeUserInput(startsWith);
    final List<dynamic> response =
        await _callApi('branches?nameFragment=$sanitized&\$fields=id,name');

    return response.map((dynamic e) => _branchFromJson(e));
  }

  static Branch _branchFromJson(Map<String, dynamic> json) => Branch(
        id: json['id'],
        name: json['name'],
      );

  @override
  Future<Caller> caller({String id}) {
    return _callerCache.get(id, (String id) async {
      final dynamic response =
          await _callApi('persons/id/$id?\$fields=id,dynamicName,branch');
      final dynamic fixed = await _fixCaller(_subPathCaller, response);
      return _callerFromJson(fixed);
    });
  }

  Future<Caller> _callerFromJson(Map<String, dynamic> json) async => Caller(
        id: json['id'],
        name: json['name'],
        avatar: json['avatar'],
        branch: await branch(id: json['branchId']),
      );

  @override
  Future<Iterable<Caller>> callers({
    @required String startsWith,
    @required Branch branch,
  }) async {
    final String sanitized = _sanatizeUserInput(startsWith);
    final List<dynamic> response = await _callApi(
      'persons?lastname=$sanitized&\$fields=id,dynamicName,branch',
    );

    final List<dynamic> fixed = await Future.wait<dynamic>(
      response.map(
        (dynamic json) => _fixCaller(_subPathCaller, json),
      ),
    );

    return null;
    // return fixed.map((dynamic json) => Caller.fromJson(json));
  }

  @override
  Future<Category> category({String id}) async {
    return (await categories()).firstWhere(
      (Category c) => c.id == id,
      orElse: () => throw TdModelNotFoundException('no category for id: $id'),
    );
  }

  @override
  Future<Iterable<Category>> categories() async {
    final List<dynamic> response = await _callApi('incidents/categories');
    return response.map((dynamic e) => null);
    // return response.map((dynamic e) => Category.fromJson(e));
  }

  @override
  Future<SubCategory> subCategory({String id}) async {
    final List<dynamic> response = await _callApi('incidents/subcategories');
    final dynamic theOne = response.firstWhere(
      (dynamic json) => json['id'] == id,
      orElse: () =>
          throw TdModelNotFoundException('no sub category for id: $id'),
    );

    return null;
    // return SubCategory.fromJson(_fixSubCategory(theOne));
  }

  @override
  Future<Iterable<SubCategory>> subCategories({Category category}) async {
    final List<dynamic> response = await _callApi('incidents/subcategories');
    return response
        .where((dynamic json) => json['category']['id'] == category.id)
        .map<dynamic>((dynamic json) => _fixSubCategory(json))
        .map((dynamic json) => null);
    // .map((dynamic json) => SubCategory.fromJson(json));
  }

  dynamic _fixSubCategory(dynamic json) {
    json['categoryId'] = json['category']['id'];
    return json;
  }

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
    final List<dynamic> response = await _callApi('incidents/durations');
    return response.map((dynamic e) => null);
    // return response.map((dynamic e) => IncidentDuration.fromJson(e));
  }

  @override
  Future<IncidentOperator> incidentOperator({String id}) async {
    final dynamic response = await _callApi('operators/id/$id');
    final dynamic fixed = await _fixPerson(_subPathOperator, response);
    return null;
    // return IncidentOperator.fromJson(fixed);
  }

  @override
  Future<IncidentOperator> currentIncidentOperator() async {
    final dynamic response = await _callApi('operators/current');
    final dynamic fixed = await _fixPerson(_subPathOperator, response);
    return null;
    // return IncidentOperator.fromJson(fixed);
  }

  @override
  Future<Iterable<IncidentOperator>> incidentOperators({
    @required String startsWith,
  }) async {
    final String sanitized = _sanatizeUserInput(startsWith);
    final List<dynamic> response = await _callApi(
      'operators?lastname=$sanitized',
    );

    final Iterable<dynamic> filtered = response.where(
      (dynamic json) => json['firstLineCallOperator'],
    );

    final List<dynamic> fixed = await Future.wait<dynamic>(
      filtered.map(
        (dynamic json) => _fixPerson(_subPathOperator, json),
      ),
    );

    return null;
    // return fixed.map((dynamic json) => IncidentOperator.fromJson(json));
  }

  dynamic _callApi(String endPoint) async {
    if (_url == null) {
      throw StateError('call init first');
    }

    http.Response res;
    try {
      res = await _client
          .get(
            '$_url/tas/api/$endPoint',
            headers: _authHeaders,
          )
          .timeout(
            _timeOut,
            onTimeout: () => throw TdTimeOutException(
              'time out for: $endPoint',
            ),
          );
    } on TdTimeOutException {
      rethrow;
    } catch (error) {
      throw TdServerException('error get $endPoint error: $error');
    }

    return _processServerResponse(endPoint, res);
  }

  dynamic _processServerResponse(String endPoint, http.Response res) {
    if (res.statusCode == 200 || res.statusCode == 206) {
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

  Future<dynamic> _fixCaller(String subPath, dynamic json) async {
    json['branchId'] = json['branch']['id'];
    return _fixPerson(subPath, json);
  }

  Future<dynamic> _fixPerson(String subPath, dynamic json) async {
    json['name'] = json['dynamicName'];
    json['avatar'] = await _avatarForPerson(subPath, json['id']);
    return json;
  }

  Future<String> _avatarForPerson(String subPath, String id) async {
    final dynamic response = await _callApi('avatars/$subPath/$id');
    return response['image'];
  }

  String _sanatizeUserInput(String input) => Uri.encodeComponent(input);

  Map<String, String> _createAuthHeaders(Credentials credentials) {
    final String encoded = utf8
        .fuse(base64)
        .encode('${credentials.loginName}:${credentials.password}');

    return <String, String>{
      HttpHeaders.authorizationHeader: 'Basic ' + encoded,
      HttpHeaders.acceptHeader: 'application/json',
    };
  }
}
