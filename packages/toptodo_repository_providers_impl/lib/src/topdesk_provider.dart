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
    final List<dynamic> response = await _callApi();
    return response.map((dynamic e) => IncidentDuration.fromJson(e));
  }

  @override
  Future<Iterable<Branch>> fetchBranches({@required String startsWith}) {
    return null;
  }

  dynamic _callApi() async {
    if (_url == null) {
      throw StateError('call init first');
    }

    final http.Response res = await http.get(
      '$_url/tas/api/incidents/durations',
      headers: _authHeaders,
    );

    return json.decode(res.body);
  }

  @override
  Future<Iterable<Person>> fetchPersons({
    @required String startsWith,
    @required Branch linkedTo,
  }) async {
    return null;
  }

  @override
  Future<Iterable<Category>> fetchCategories() {
    return null;
  }

  @override
  Future<Iterable<SubCategory>> fetchSubCategories({String categoryId}) {
    return null;
  }
}
