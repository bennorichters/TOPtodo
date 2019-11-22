import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toptodo_data/toptodo_data.dart';

const Duration _latency = Duration(milliseconds: 1500);

class FakeTopdeskProvider implements TopdeskProvider {
  @override
  void init(Credentials credentials) {
    print('init called with $credentials');
  }

  @override
  Future<Iterable<IncidentDuration>> fetchDurations() async {
    final List<dynamic> response = await _readJson('durations.json');
    return response.map(
      (dynamic e) => IncidentDuration.fromJson(e),
    );
  }

  @override
  Future<Iterable<Branch>> fetchBranches({@required String startsWith}) async {
    final String swLower = startsWith.toLowerCase();

    final List<dynamic> response = await _readJson('branches.json');
    return response
        .map(
          (dynamic e) => Branch.fromJson(e),
        )
        .where(
          (Branch b) => b.name.toLowerCase().startsWith(swLower),
        );
  }

  @override
  Future<Iterable<Person>> fetchPersons({
    @required String startsWith,
    @required Branch linkedTo,
  }) async {
    final String swLower = startsWith.toLowerCase();

    final List<dynamic> response = await _readJson('persons.json');
    return response
        .map(
          (dynamic e) => Person.fromJson(e),
        )
        .where(
          (Person p) =>
              (p.branchid == linkedTo.id) &&
              p.name.toLowerCase().startsWith(swLower),
        );
  }

  @override
  Future<Iterable<Category>> fetchCategories() async {
    final List<dynamic> response = await _readJson('categories.json');
    return response.map(
      (dynamic e) => Category.fromJson(e),
    );
  }

  @override
  Future<Iterable<SubCategory>> fetchSubCategories({String categoryId}) async {
    final List<dynamic> response = await _readJson('categories.json');
    return response
        .map(
          (dynamic e) => SubCategory.fromJson(e),
        )
        .where(
          (SubCategory s) => s.categoryId == categoryId,
        );
  }

  Future<List<dynamic>> _readJson(String file) async {
    // This explicit inclusion of the package name seems necessary.
    // Unit tests will run without (only using 'json/'), but on
    // a device that fails.
    final String content = await rootBundle
        .loadString('packages/toptodo_topdesk_provider_mock/json/' + file);

    return Future<List<dynamic>>.delayed(_latency, () => json.decode(content));
  }
}
