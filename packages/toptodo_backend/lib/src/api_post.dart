import 'dart:io';

import 'package:toptodo_data/toptodo_data.dart';

void respondToPost(HttpRequest request, TopdeskProvider tdProvider) async {
  if (request.uri.path == '/tas/api/incidents') {
    final number = await tdProvider.createTdIncident(
      settings: null,
      briefDescription: '',
    );

    request.response.headers
        .add(HttpHeaders.contentTypeHeader, 'application/json');
    request.response.statusCode = 201;
    request.response.write('{"number": "$number"}');
  } else {
    request.response.statusCode = 404;
  }
}
