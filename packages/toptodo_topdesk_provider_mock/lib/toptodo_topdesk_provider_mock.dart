import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:toptodo_data/toptodo_data.dart';

class FakeTopdeskProvider implements TopdeskProvider {
  @override
  void init(Credentials credentials) {
    print('init called with $credentials');
  }

  @override
  Future<Iterable<IncidentDuration>> fetchDurations() async {
    final List<dynamic> response = await _readJson('durations.json');
    return response.map((dynamic e) => IncidentDuration.fromMappedJson(e));
  }

  @override
  Future<Iterable<Branch>> fetchBranches(String startsWith) {
    final String swLower = startsWith.toLowerCase();
    return Future<Iterable<Branch>>.delayed(
      Duration(seconds: 2),
      () => const <Branch>[
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

  Future<List<dynamic>> _readJson(String file) async {
    final String content = await rootBundle.loadString('json/' + file);
    return json.decode(content);
  }
}

