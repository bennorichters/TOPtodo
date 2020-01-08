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
  Future<TdBranch> tdBranch({String id}) async => (await tdBranches(
        startsWith: '',
      ))
          .firstWhere(
        (TdBranch b) => b.id == id,
        orElse: () =>
            throw TdModelNotFoundException('no branch found with id: $id'),
      );

  @override
  Future<Iterable<TdBranch>> tdBranches({@required String startsWith}) async {
    final swLower = startsWith.toLowerCase();

    final List<dynamic> response = await _readJson(json_branches.branches);
    return response
        .map(
          (dynamic e) => _branchFromJson(e),
        )
        .where(
          (TdBranch b) => b.name.toLowerCase().startsWith(swLower),
        );
  }

  static TdBranch _branchFromJson(Map<String, dynamic> json) => TdBranch(
        id: json['id'],
        name: json['name'],
      );

  @override
  Future<TdCaller> tdCaller({String id}) async {
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
      await tdBranch(id: found['branchId']),
    );
  }

  @override
  Future<Iterable<TdCaller>> tdCallers(
      {String startsWith, TdBranch tdBranch}) async {
    final swLower = startsWith.toLowerCase();

    final avatar = await _avatar();
    final List<dynamic> response = await _readJson(json_callers.callers);
    return response
        .where(
          (dynamic e) =>
              (e['branchId'] == tdBranch.id) &&
              e['name'].toLowerCase().startsWith(swLower),
        )
        .map(
          (dynamic e) => _callerFromJson(e, avatar, tdBranch),
        );
  }

  static TdCaller _callerFromJson(
    Map<String, dynamic> json,
    String avatar,
    TdBranch branch,
  ) =>
      TdCaller(
        id: json['id'],
        name: json['name'],
        avatar: avatar,
        branch: branch,
      );

  @override
  Future<TdCategory> tdCategory({String id}) async {
    return (await tdCategories()).firstWhere(
      (TdCategory c) => c.id == id,
      orElse: () => throw TdModelNotFoundException('no category for id: $id'),
    );
  }

  @override
  Future<Iterable<TdCategory>> tdCategories() async {
    final List<dynamic> response = await _readJson(json_categories.categories);
    return response.map(
      (dynamic e) => _categofryFromJson(e),
    );
  }

  static TdCategory _categofryFromJson(Map<String, dynamic> json) => TdCategory(
        id: json['id'],
        name: json['name'],
      );

  @override
  Future<TdSubcategory> tdSubcategory({String id}) async {
    final List<dynamic> response =
        await _readJson(json_sub_categories.subCategories);
    final dynamic json = response.firstWhere(
      (dynamic e) => e['id'] == id,
      orElse: () =>
          throw TdModelNotFoundException('no sub category for id: $id'),
    );

    return _subCategoryFromJson(json, await tdCategory(id: json['categoryId']));
  }

  @override
  Future<Iterable<TdSubcategory>> tdSubcategories(
      {TdCategory tdCategory}) async {
    final List<dynamic> response =
        await _readJson(json_sub_categories.subCategories);
    return response
        .where(
          (dynamic e) => e['categoryId'] == tdCategory.id,
        )
        .map(
          (dynamic e) => _subCategoryFromJson(e, tdCategory),
        );
  }

  TdSubcategory _subCategoryFromJson(
    Map<String, dynamic> json,
    TdCategory category,
  ) =>
      TdSubcategory(
        id: json['id'],
        name: json['name'],
        category: category,
      );

  @override
  Future<Iterable<TdDuration>> tdDurations() async {
    final List<dynamic> response = await _readJson(json_durations.durations);
    return response.map(
      (dynamic e) => _incidentDurationFromJson(e),
    );
  }

  static TdDuration _incidentDurationFromJson(
    Map<String, dynamic> json,
  ) =>
      TdDuration(
        id: json['id'],
        name: json['name'],
      );

  @override
  Future<TdDuration> tdDuration({String id}) async {
    return (await tdDurations()).firstWhere(
      (TdDuration e) => e.id == id,
      orElse: () =>
          throw TdModelNotFoundException('no incident duration for id: $id'),
    );
  }

  @override
  Future<TdOperator> tdOperator({String id}) async {
    return (await tdOperators(startsWith: '')).firstWhere(
      (TdOperator e) => e.id == id,
      orElse: () => throw TdModelNotFoundException('no operator for id: $id'),
    );
  }

  @override
  Future<Iterable<TdOperator>> tdOperators({
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

  TdOperator _incidentOperatorFromJson(
    Map<String, dynamic> json,
    String avatar,
  ) =>
      TdOperator(
        id: json['id'],
        name: json['name'],
        avatar: avatar,
        firstLine: true,
        secondLine: true,
      );

  TdOperator _currentOperator;

  @override
  Future<TdOperator> currentTdOperator() async =>
      (_currentOperator ??= (await tdOperators(startsWith: '')).first);

  Future<String> _avatar() async {
    return (await _readJson(json_avatar.avatar))['black'];
  }

  @override
  Future<String> createTdIncident({
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
