import 'dart:convert';

import 'package:flutter/material.dart';
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
  Future<Iterable<Branch>> fetchBranches({@required String startsWith}) async {
    final String swLower = startsWith.toLowerCase();

    final List<dynamic> response = await _readJson('branches.json');
    return response
        .map((dynamic e) => Branch.fromMappedJson(e))
        .where((Branch b) => b.name.toLowerCase().startsWith(swLower));
  }

  Future<List<dynamic>> _readJson(String file) async {
    final String content = await rootBundle.loadString('json/' + file);
    return json.decode(content);
  }

  @override
  Future<Iterable<Person>> fetchPersons({
    @required String startsWith,
    @required String branchId,
  }) async {
    final String swLower = startsWith.toLowerCase();

    final List<dynamic> response = await _readJson('persons.json');
    return response.map((dynamic e) => Person.fromMappedJson(e)).where(
        (Person p) =>
            (p.branchid == branchId) &&
            p.name.toLowerCase().startsWith(swLower));
  }
}
