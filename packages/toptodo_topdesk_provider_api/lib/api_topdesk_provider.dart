import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:toptodo_data/toptodo_data.dart';

class ApiTopdeskProvider extends TopdeskProvider {
  static const String _subPathOperator = 'operator';
  static const String _subPathCaller = 'person';

  String _url;
  Map<String, String> _authHeaders;
  http.Client _client;

  @override
  void init(Credentials credentials, {http.Client client}) {
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
  Future<Iterable<Branch>> branches({@required String startsWith}) async {
    final String sanitized = Uri.encodeFull(startsWith);
    final List<dynamic> response =
        await _callApi('branches?nameFragment=$sanitized&\$fields=id,name');

    return response.map((dynamic e) => Branch.fromJson(e));
  }

  @override
  Future<Iterable<Caller>> callers({
    @required String startsWith,
    @required Branch branch,
  }) async {
    final String sanitized = Uri.encodeFull(startsWith);
    final List<dynamic> response = await _callApi(
      'persons?lastname=$sanitized&\$fields=id,dynamicName',
    );

    final List<dynamic> fixed = await Future.wait<dynamic>(
      response.map(
        (dynamic json) => _fixPerson(_subPathCaller, json),
      ),
    );

    return fixed.map((dynamic json) => Caller.fromJson(json));
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
    return response.map((dynamic e) => Category.fromJson(e));
  }

  @override
  Future<Iterable<SubCategory>> subCategories({Category category}) async {
    final List<dynamic> response = await _callApi('incidents/subcategories');
    return response
        .where((dynamic json) => json['category']['id'] == category.id)
        .map((dynamic json) => SubCategory.fromJson(json));
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
    return response.map((dynamic e) => IncidentDuration.fromJson(e));
  }

  @override
  Future<IncidentOperator> currentIncidentOperator() async {
    final dynamic response = await _callApi('operators/current');
    final dynamic fixed = await _fixPerson(_subPathOperator, response);
    return IncidentOperator.fromJson(fixed);
  }

  @override
  Future<Iterable<IncidentOperator>> incidentOperators({
    @required String startsWith,
  }) async {
    final String sanitized = Uri.encodeFull(startsWith);
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

    return fixed.map((dynamic json) => IncidentOperator.fromJson(json));
  }

  Map<String, String> _createAuthHeaders(Credentials credentials) {
    final String encoded = utf8
        .fuse(base64)
        .encode('${credentials.loginName}:${credentials.password}');

    return <String, String>{
      HttpHeaders.authorizationHeader: 'Basic ' + encoded,
      HttpHeaders.acceptHeader: 'application/json',
    };
  }

  dynamic _callApi(String endPoint) async {
    if (_url == null) {
      throw StateError('call init first');
    }

    final http.Response res = await _client.get(
      '$_url/tas/api/$endPoint',
      headers: _authHeaders,
    );

    if (res.statusCode == 204) {
      return json.decode('[]');
    }

    if (res.statusCode == 200 || res.statusCode == 206) {
      return json.decode(res.body);
    }
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

  @override
  Future<Branch> branch({String id}) {
    return null;
  }

  @override
  Future<Caller> caller({String id}) {
    return null;
  }

  @override
  Future<IncidentOperator> incidentOperator({String id}) {
    return null;
  }

  @override
  Future<SubCategory> subCategory({String id}) {
    return null;
  }
}
