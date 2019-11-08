import 'package:toptopdo/data/model/credentials.dart';

import 'model/topdesk_elements.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

typedef TopdeskProvider TopdeskProviderFactory(Credentials credentials);

abstract class TopdeskProvider {
  List<IncidentDuration> fetchDurations();
}

class ApiTopdeskProvider extends TopdeskProvider {
  final Credentials credentials;
  ApiTopdeskProvider(this.credentials);

  @override
  List<IncidentDuration> fetchDurations() {
    _topdeskConnect();
    return null;
  }

  void _topdeskConnect() async {
    final url = '${credentials.url}/tas/api/incidents/durations';

    var res = await http.get(
      url,
      headers: _topdeskAuthHeaders(),
    );

    print(res.statusCode);

    List<dynamic> elements = json.decode(res.body);

    print(elements);
  }

  Map<String, String> _topdeskAuthHeaders() {
    var stringToBase64 = utf8.fuse(base64);
    var encoded = stringToBase64
        .encode('${credentials.loginName}:${credentials.password}');

    return {
      HttpHeaders.authorizationHeader: 'Basic ' + encoded,
      HttpHeaders.acceptHeader: 'application/json',
    };
  }
}
