import 'package:toptopdo/data/model/credentials.dart';

import 'model/topdesk_elements.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

abstract class TopdeskProvider {
  void init(Credentials credentials);
  List<IncidentDuration> fetchDurations();
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
  List<IncidentDuration> fetchDurations() {
    _callApi();
    return null;
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
