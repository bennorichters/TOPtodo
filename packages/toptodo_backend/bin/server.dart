import 'dart:io';

import '../lib/src/request_handler.dart';

Future main() async {
  var server = await HttpServer.bind(
    'localhost',
    3000,
  );

  await for (HttpRequest request in server) {
    await requestHandler(request);
  }
}
