import 'package:toptopdo/data/model/credentials.dart';

import 'model/topdesk_elements.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

abstract class TopdeskProvider {
  void init(Credentials credentials);
  Future<List<IncidentDuration>> fetchDurations();
}

class ApiTopdeskProvider extends TopdeskProvider {
  String _url;
  Map<String, String> _authHeaders;

  void init(Credentials credentials) {
    _url = credentials.url;
    _authHeaders = _createAuthHeaders(credentials);
  }

  Map<String, String> _createAuthHeaders(Credentials credentials) {
    var stringToBase64 = utf8.fuse(base64);
    var encoded = stringToBase64
        .encode('${credentials.loginName}:${credentials.password}');

    return {
      HttpHeaders.authorizationHeader: 'Basic ' + encoded,
      HttpHeaders.acceptHeader: 'application/json',
    };
  }

  @override
  Future<List<IncidentDuration>> fetchDurations() async {
    List response = await _callApi();
    return response.map((e) => IncidentDuration.fromMappedJson(e)).toList();
  }

  dynamic _callApi() async {
    if (_url == null) throw StateError('call init first');

    var res = await http.get(
      '$_url/tas/api/incidents/durations',
      headers: _authHeaders,
    );

    return json.decode(res.body);
  }
}

class FakeTopdeskProvider implements TopdeskProvider {
  @override
  void init(Credentials credentials) {
    print('init called with $credentials');
  }

  @override
  Future<List<IncidentDuration>> fetchDurations() async {
    return Future.delayed(
      Duration(seconds: 2),
      () => [
        IncidentDuration(
          id: 'a',
          name: '1 minute',
        ),
        IncidentDuration(
          id: 'b',
          name: '1 hour',
        ),
        IncidentDuration(
          id: 'c',
          name: '2 hours',
        ),
        IncidentDuration(
          id: 'd',
          name: '1 week',
        ),
        IncidentDuration(
          id: 'e',
          name: '1 month',
        ),
      ],
    );
  }
}
