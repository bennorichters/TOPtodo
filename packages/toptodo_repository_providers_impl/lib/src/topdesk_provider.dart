import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toptodo_data/toptodo_data.dart';

class ApiTopdeskProvider extends TopdeskProvider {
  final HtmlEscape _sanitizer = const HtmlEscape();
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
  Future<Iterable<Branch>> branches({@required String startsWith}) async {
    return const Iterable<Branch>.empty();
  }

  dynamic _callApi(String endPoint) async {
    if (_url == null) {
      throw StateError('call init first');
    }

    final http.Response res = await http.get(
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

  @override
  Future<Iterable<Caller>> callers({
    @required String startsWith,
    @required Branch branch,
  }) async {
    return const Iterable<Caller>.empty();
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
    final String sanitized = _sanitizer.convert(startsWith);
    final List<dynamic> response = await _callApi(
      'operators?firstname=$sanitized',
    );

    final Iterable<dynamic> filtered = response.where(
      (dynamic json) => json['firstLineCallOperator'],
    );

    final List<dynamic> fixed = await Future.wait<dynamic>(
      filtered.map(
        (dynamic json) => _fixOperator(json),
      ),
    );

    return fixed.map((dynamic json) => Operator.fromJson(json));
  }

  Future<dynamic> _fixOperator(dynamic json) async {
    json['name'] = json['dynamicName'];
    json['avatar'] = await avatarForPerson(json['id']);
    return json;
  }

  @override
  Future<Operator> currentOperator() async {
    final dynamic response = await _callApi('operators/current');
    response['name'] = response['dynamicName'];
    return Operator.fromJson(response);
  }

  Future<String> avatarForPerson(String id) async {
    final dynamic response = await _callApi('avatars/operator/$id');
    return response['image'];
  }
}
