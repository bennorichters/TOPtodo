import 'dart:io';
import 'package:appengine/appengine.dart';

void main() async {
  await runAppEngine(requestHandler);
}

void requestHandler(HttpRequest request) {
  request.response
    ..write('Hello, world!')
    ..close();
}
