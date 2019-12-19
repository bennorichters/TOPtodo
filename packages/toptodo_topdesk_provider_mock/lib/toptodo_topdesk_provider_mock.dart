import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:resource/resource.dart';
import 'package:toptodo_data/toptodo_data.dart';

class FakeTopdeskProvider implements TopdeskProvider {
  FakeTopdeskProvider({this.latency = const Duration(milliseconds: 1500)});
  final Duration latency;

  @override
  void init(Credentials credentials) {
    // Ignore
  }

  @override
  void dispose() {
    // Ignore
  }

  @override
  Future<Branch> branch({String id}) async => (await branches(
        startsWith: '',
      ))
          .firstWhere(
        (Branch b) => b.id == id,
        orElse: () =>
            throw TdModelNotFoundException('no branch found with id: $id'),
      );

  @override
  Future<Iterable<Branch>> branches({@required String startsWith}) async {
    final String swLower = startsWith.toLowerCase();

    final List<dynamic> response = await _readJson('branches');
    return response
        .map(
          (dynamic e) => _branchFromJson(e),
        )
        .where(
          (Branch b) => b.name.toLowerCase().startsWith(swLower),
        );
  }

  static Branch _branchFromJson(Map<String, dynamic> json) => Branch(
        id: json['id'],
        name: json['name'],
      );

  @override
  Future<Caller> caller({String id}) async {
    final String avatar = await _avatar();

    final List<dynamic> response = await _readJson('callers');
    final dynamic found = response.firstWhere(
      (dynamic e) => e['id'] == id,
      orElse: () => throw TdModelNotFoundException(
        'no caller for id: $id',
      ),
    );

    return _callerFromJson(
      found,
      avatar,
      await branch(id: found['branchId']),
    );
  }

  @override
  Future<Iterable<Caller>> callers({
    @required String startsWith,
    @required Branch branch,
  }) async {
    final String swLower = startsWith.toLowerCase();

    final String avatar = await _avatar();
    final List<dynamic> response = await _readJson('callers');
    return response
        .where(
          (dynamic e) =>
              (e['branchId'] == branch.id) &&
              e['name'].toLowerCase().startsWith(swLower),
        )
        .map(
          (dynamic e) => _callerFromJson(e, avatar, branch),
        );
  }

  static Caller _callerFromJson(
    Map<String, dynamic> json,
    String avatar,
    Branch branch,
  ) =>
      Caller(
        id: json['id'],
        name: json['name'],
        avatar: avatar,
        branch: branch,
      );

  @override
  Future<Category> category({String id}) async {
    return (await categories()).firstWhere(
      (Category c) => c.id == id,
      orElse: () => throw TdModelNotFoundException('no category for id: $id'),
    );
  }

  @override
  Future<Iterable<Category>> categories() async {
    final List<dynamic> response = await _readJson('categories');
    return response.map(
      (dynamic e) => _categofryFromJson(e),
    );
  }

  static Category _categofryFromJson(Map<String, dynamic> json) => Category(
        id: json['id'],
        name: json['name'],
      );

  @override
  Future<SubCategory> subCategory({String id}) async {
    final List<dynamic> response = await _readJson('sub_categories');
    final dynamic json = response.firstWhere(
      (dynamic e) => e['id'] == id,
      orElse: () =>
          throw TdModelNotFoundException('no sub category for id: $id'),
    );

    return _subCategoryFromJson(json, await category(id: json['categoryId']));
  }

  @override
  Future<Iterable<SubCategory>> subCategories({Category category}) async {
    final List<dynamic> response = await _readJson('sub_categories');
    return response
        .where(
          (dynamic e) => e['categoryId'] == category.id,
        )
        .map(
          (dynamic e) => _subCategoryFromJson(e, category),
        );
  }

  SubCategory _subCategoryFromJson(
    Map<String, dynamic> json,
    Category category,
  ) =>
      SubCategory(
        id: json['id'],
        name: json['name'],
        category: category,
      );

  @override
  Future<Iterable<IncidentDuration>> incidentDurations() async {
    final List<dynamic> response = await _readJson('durations');
    return response.map(
      (dynamic e) => _incidentDurationFromJson(e),
    );
  }

  static IncidentDuration _incidentDurationFromJson(
    Map<String, dynamic> json,
  ) =>
      IncidentDuration(
        id: json['id'],
        name: json['name'],
      );

  @override
  Future<IncidentDuration> incidentDuration({String id}) async {
    return (await incidentDurations()).firstWhere(
      (IncidentDuration e) => e.id == id,
      orElse: () =>
          throw TdModelNotFoundException('no incident duration for id: $id'),
    );
  }

  @override
  Future<IncidentOperator> incidentOperator({String id}) async {
    return (await incidentOperators(startsWith: '')).firstWhere(
      (IncidentOperator e) => e.id == id,
      orElse: () => throw TdModelNotFoundException('no operator for id: $id'),
    );
  }

  @override
  Future<Iterable<IncidentOperator>> incidentOperators({
    @required String startsWith,
  }) async {
    final String swLower = startsWith.toLowerCase();

    final String avatar = await _avatar();
    final List<dynamic> response = await _readJson('operators');
    return response
        .where(
          (dynamic e) => e['name'].toLowerCase().startsWith(swLower),
        )
        .map(
          (dynamic e) => _incidentOperatorFromJson(e, avatar),
        );
  }

  IncidentOperator _incidentOperatorFromJson(
    Map<String, dynamic> json,
    String avatar,
  ) =>
      IncidentOperator(
        id: json['id'],
        name: json['name'],
        avatar: avatar,
      );

  @override
  Future<IncidentOperator> currentIncidentOperator() async =>
      (await incidentOperators(startsWith: '')).first;

  Future<String> _avatar() async {
    return (await _readJson('avatar'))['black'];
  }

  Future<dynamic> _readJson(String fileName) async {
    final Resource resource = Resource(
      'package:toptodo_topdesk_provider_mock/json/$fileName.json',
    );
    final String content = await resource.readAsString(encoding: utf8);

    return Future<dynamic>.delayed(
      latency,
      () => json.decode(content),
    );
  }
}
