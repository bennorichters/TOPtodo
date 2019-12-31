import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:toptodo_data/toptodo_data.dart';
import 'package:toptodo_topdesk_provider_mock/json/avatar.dart' as json_avatar;
import 'package:toptodo_topdesk_provider_mock/json/branches.dart'
    as json_branches;
import 'package:toptodo_topdesk_provider_mock/json/callers.dart'
    as json_callers;
import 'package:toptodo_topdesk_provider_mock/json/categories.dart'
    as json_categories;
import 'package:toptodo_topdesk_provider_mock/json/durations.dart'
    as json_durations;
import 'package:toptodo_topdesk_provider_mock/json/operators.dart'
    as json_operators;
import 'package:toptodo_topdesk_provider_mock/json/sub_categories.dart'
    as json_sub_categories;

// Importing all json files as Strings in dart files
// Using File our Resource (from the Dart resource package) fails
// as soon as this is included in a Flutter project
// See https://stackoverflow.com/questions/59421963

class FakeTopdeskProvider implements TopdeskProvider {
  FakeTopdeskProvider({this.latency = const Duration(milliseconds: 1500)});
  final Duration latency;

  int _incidentNumber = 0;

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
    final swLower = startsWith.toLowerCase();

    final List<dynamic> response = await _readJson(json_branches.branches);
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
    final avatar = await _avatar();

    final List<dynamic> response = await _readJson(json_callers.callers);
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
    final swLower = startsWith.toLowerCase();

    final avatar = await _avatar();
    final List<dynamic> response = await _readJson(json_callers.callers);
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
    final List<dynamic> response = await _readJson(json_categories.categories);
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
    final List<dynamic> response =
        await _readJson(json_sub_categories.subCategories);
    final dynamic json = response.firstWhere(
      (dynamic e) => e['id'] == id,
      orElse: () =>
          throw TdModelNotFoundException('no sub category for id: $id'),
    );

    return _subCategoryFromJson(json, await category(id: json['categoryId']));
  }

  @override
  Future<Iterable<SubCategory>> subCategories({Category category}) async {
    final List<dynamic> response =
        await _readJson(json_sub_categories.subCategories);
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
    final List<dynamic> response = await _readJson(json_durations.durations);
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
    final swLower = startsWith.toLowerCase();

    final avatar = await _avatar();
    final List<dynamic> response = await _readJson(json_operators.operators);
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
        firstLine: true,
        secondLine: true,
      );

  IncidentOperator _currentOperator;

  @override
  Future<IncidentOperator> currentIncidentOperator() async =>
      (_currentOperator ??= (await incidentOperators(startsWith: '')).first);

  Future<String> _avatar() async {
    return (await _readJson(json_avatar.avatar))['black'];
  }

  @override
  Future<String> createIncident({
    @required String briefDescription,
    @required Settings settings,
    String request,
  }) {
    return Future.delayed(latency, () => (++_incidentNumber).toString());
  }

  Future<dynamic> _readJson(String content) async {
    return Future<dynamic>.delayed(
      latency,
      () => json.decode(content),
    );
  }
}
