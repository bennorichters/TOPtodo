import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:toptopdo/data/model/credentials.dart';

import 'model/topdesk_elements.dart';

abstract class TopdeskProvider {
  void init(Credentials credentials);

  Future<Iterable<Branch>> fetchBranches(String startsWith);
  Future<Iterable<IncidentDuration>> fetchDurations();
}

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
    return response
        .map((dynamic e) => IncidentDuration.fromMappedJson(e));
  }

  @override
  Future<Iterable<Branch>> fetchBranches(String startsWith) {
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
}

class FakeTopdeskProvider implements TopdeskProvider {
  @override
  void init(Credentials credentials) {
    print('init called with $credentials');
  }

  @override
  Future<Iterable<IncidentDuration>> fetchDurations() async {
    return Future<Iterable<IncidentDuration>>.delayed(
      Duration(seconds: 2),
      () => <IncidentDuration>[
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

  @override
  Future<Iterable<Branch>> fetchBranches(String startsWith) {
    final String swLower = startsWith.toLowerCase();
    return Future<Iterable<Branch>>.delayed(
      Duration(seconds: 2),
      () => <Branch>[
        Branch(
          id: 'a',
          name: 'Branch A',
        ),
        Branch(
          id: 'b',
          name: 'Branch B',
        ),
        Branch(
          id: 'c',
          name: 'C Branch',
        ),
        Branch(
          id: 'd',
          name: 'D Branch',
        ),
        Branch(
          id: 'e',
          name: 'DD Branch',
        ),
      ].where((Branch b) => b.name.toLowerCase().startsWith(swLower)),
    );
  }
}
