import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:toptodo_data/toptodo_data.dart';

class FakeTopdeskProvider implements TopdeskProvider {
  FakeTopdeskProvider({this.latency = const Duration(milliseconds: 1500)});
  final Duration latency;

  @override
  void init(Credentials credentials) {
    // Ignore
  }

  @override
  Future<Branch> branch({String id}) async => (await branches(
        startsWith: '',
      ))
          .firstWhere(
        (Branch b) => b.id == id,
        orElse: () => throw ArgumentError('no branch found with id: $id'),
      );

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
  Future<Caller> caller({String id}) async {
    final String avatar = await _avatar();

    final List<dynamic> response = await _readJson('callers.json');
    final dynamic found = response.firstWhere(
      (dynamic e) => e['id'] == id,
      orElse: () => throw ArgumentError(
        'no caller for id: $id',
      ),
    );

    found['avatar'] = avatar;
    return Caller.fromJson(found);
  }

  @override
  Future<Iterable<Caller>> callers({
    @required String startsWith,
    @required Branch branch,
  }) async {
    final String swLower = startsWith.toLowerCase();

    final String avatar = await _avatar();
    final List<dynamic> response = await _readJson('callers.json');
    return response
        .where(
      (dynamic e) =>
          (e['branchid'] == branch.id) &&
          e['name'].toLowerCase().startsWith(swLower),
    )
        .map(
      (dynamic e) {
        e['avatar'] = avatar;
        return Caller.fromJson(e);
      },
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
  Future<Iterable<IncidentDuration>> incidentDurations() async {
    final List<dynamic> response = await _readJson('durations.json');
    return response.map(
      (dynamic e) => IncidentDuration.fromJson(e),
    );
  }

  @override
  Future<Iterable<IncidentOperator>> operators({
    @required String startsWith,
  }) async {
    final String swLower = startsWith.toLowerCase();

    final String avatar = await _avatar();
    final List<dynamic> response = await _readJson('operators.json');
    return response
        .where(
      (dynamic e) => e['name'].toLowerCase().startsWith(swLower),
    )
        .map(
      (dynamic e) {
        e['avatar'] = avatar;
        return IncidentOperator.fromJson(e);
      },
    );
  }

  @override
  Future<IncidentOperator> currentIncidentOperator() async =>
      (await operators(startsWith: '')).first;

  Future<String> _avatar() async {
    return (await _readJson('avatar.json'))['black'];
  }

  Future<dynamic> _readJson(String fileName) async {
    final File file = File('./json/$fileName');
    final String content = await file.readAsString();

    return Future<dynamic>.delayed(
      latency,
      () => json.decode(content),
    );
  }

  @override
  Future<Category> category({String id}) {
    return null;
  }

  @override
  Future<IncidentDuration> incidentDuration({String id}) {
    return null;
  }

  @override
  Future<IncidentOperator> incidentOperator({String id}) {
    return null;
  }

  @override
  Future<SubCategory> subCategory({String id}) {
    return null;
  }
}
