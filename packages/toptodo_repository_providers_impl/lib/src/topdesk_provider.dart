import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toptodo_data/toptodo_data.dart';

class ApiTopdeskProvider extends TopdeskProvider {
  String _url;
  Map<String, String> _authHeaders;

  @override
  void init(Credentials credentials) {
    _url = credentials.url;
    _authHeaders = _createAuthHeaders(credentials);
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

  @override
  Future<Iterable<IncidentDuration>> fetchDurations() async {
    final List<dynamic> response = await _callApi('incident/durations');
    return response.map((dynamic e) => IncidentDuration.fromJson(e));
  }

  @override
  Future<Iterable<Branch>> fetchBranches({@required String startsWith}) {
    return null;
  }

  dynamic _callApi(String endPoint) async {
    if (_url == null) {
      throw StateError('call init first');
    }

    final http.Response res = await http.get(
      '$_url/tas/api/$endPoint',
      headers: _authHeaders,
    );

    return json.decode(res.body);
  }

  @override
  Future<Iterable<Person>> fetchPersons({
    @required String startsWith,
    @required Branch branch,
  }) async {
    return null;
  }

  @override
  Future<Iterable<Category>> fetchCategories() async {
    final List<dynamic> response = await _callApi('incident/categories');
    return response.map((dynamic e) => Category.fromJson(e));
  }

  @override
  Future<Iterable<SubCategory>> fetchSubCategories({Category category}) async {
    final List<dynamic> response = await _callApi('incident/subcategories');
    return response
        .where((dynamic json) => json['category']['id'] == category.id)
        .map((dynamic json) => SubCategory.fromJson(json));
  }

  @override
  Future<Iterable<Operator>> fetchOperators() async {
    final List<dynamic> response = await _callApi('operators');
    return response
        .where((dynamic json) => json['firstLineCallOperator'])
        .map<dynamic>((dynamic e) {
      e.put('name', e['dynamicName']);
      return e;
    }).map((dynamic e) => Operator.fromJson(e));
  }
}
