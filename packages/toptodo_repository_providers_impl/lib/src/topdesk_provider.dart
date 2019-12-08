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
  Future<Iterable<IncidentDuration>> durations() async {
    final List<dynamic> response = await _callApi('incidents/durations');
    return response.map((dynamic e) => IncidentDuration.fromJson(e));
  }

  @override
  Future<Iterable<Branch>> branches({@required String startsWith}) {
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

    print(res.statusCode);

    return json.decode(res.body);
  }

  @override
  Future<Iterable<Caller>> callers({
    @required String startsWith,
    @required Branch branch,
  }) async {
    return null;
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
  Future<Iterable<Operator>> operators({
    @required String startsWith,
  }) async {
    final List<dynamic> response = await _callApi(
      'operators?firstname=$startsWith',
    );
    return response
        .where((dynamic json) => json['firstLineCallOperator'])
        .map<dynamic>((dynamic e) {
      e['name'] = e['dynamicName'];
      return e;
    }).map((dynamic e) => Operator.fromJson(e));
  }

  @override
  Future<Operator> currentOperator() async {
    final dynamic response = await _callApi('operators/current');
    response['name'] = response['dynamicName'];
    return Operator.fromJson(response);
  }
}
