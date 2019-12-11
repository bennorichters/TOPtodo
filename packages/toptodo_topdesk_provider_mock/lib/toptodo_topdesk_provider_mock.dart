import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toptodo_data/toptodo_data.dart';

class FakeTopdeskProvider implements TopdeskProvider {
  FakeTopdeskProvider({this.latency = const Duration(milliseconds: 1500)});
  final Duration latency;

  @override
  void init(Credentials credentials) {
    // Ignore
  }

  @override
  Future<Iterable<IncidentDuration>> durations() async {
    final List<dynamic> response = await _readJson('durations.json');
    return response.map(
      (dynamic e) => IncidentDuration.fromJson(e),
    );
  }

  @override
  Future<Iterable<Branch>> branches({@required String startsWith}) async {
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
  Future<Iterable<Caller>> callers({
    @required String startsWith,
    @required Branch branch,
  }) async {
    final String swLower = startsWith.toLowerCase();

    final List<dynamic> response = await _readJson('persons.json');
    return response
        .where(
          (dynamic e) =>
              (e['branchid'] == branch.id) &&
              e['name'].toLowerCase().startsWith(swLower),
        )
        .map(
          (dynamic e) => Caller.fromJson(e),
        );
  }

  @override
  Future<Iterable<Category>> categories() async {
    final List<dynamic> response = await _readJson('categories.json');
    return response.map(
      (dynamic e) => Category.fromJson(e),
    );
  }

  @override
  Future<Iterable<SubCategory>> subCategories({Category category}) async {
    final List<dynamic> response = await _readJson('sub_categories.json');
    return response
        .map(
          (dynamic e) => SubCategory.fromJson(e),
        )
        .where(
          (SubCategory s) => s.categoryId == category.id,
        );
  }

  @override
  Future<Iterable<Operator>> operators({
    @required String startsWith,
  }) async {
    final String swLower = startsWith.toLowerCase();

    final List<dynamic> response = await _readJson('operators.json');
    return response
        .map(
          (dynamic e) => Operator.fromJson(e),
        )
        .where(
          (Operator o) => o.name.toLowerCase().startsWith(swLower),
        );
  }

  @override
  Future<Operator> currentOperator() async =>
      (await operators(startsWith: '')).first;

  Future<List<dynamic>> _readJson(String file) async {
    // This explicit inclusion of the package name seems necessary.
    // Unit tests will run without (only using 'json/'), but on
    // a device that fails.
    final String content = await rootBundle
        .loadString('packages/toptodo_topdesk_provider_mock/json/' + file);

    return Future<List<dynamic>>.delayed(
      latency,
      () => json.decode(content),
    );
  }
}
