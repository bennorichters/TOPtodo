import 'dart:async';

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

/// A [TopdeskProvider] that returns dummy data.
///
/// This object can be useful for testing purposes. The returned data is based
/// on static json objects. The [init] and [dispose] methods of this object do
/// not do anything.
class FakeTopdeskProvider implements TopdeskProvider {
  FakeTopdeskProvider({this.latency = const Duration(milliseconds: 1500)});
  final Duration latency;

  int _incidentNumber = 0;

  @override
  Future<void> init(Credentials credentials) async {
    // Ignore
  }

  @override
  void dispose() {
    // Ignore
  }

  @override
  Future<String> apiVersion() {
    return Future.value('0.0.0');
  }

  @override
  Future<TdBranch> tdBranch({String id}) async => (await tdBranches(
        startsWith: '',
      ))
          .firstWhere(
        (TdBranch b) => b.id == id,
        orElse: () => throw TdNotFoundException('no branch found with id: $id'),
      );

  @override
  Future<Iterable<TdBranch>> tdBranches({@required String startsWith}) async {
    final swLower = startsWith.toLowerCase();

    final List<dynamic> response = await _withDelay(json_branches.branches);
    return response
        .map(
          (dynamic e) => TdBranch.fromJson(e),
        )
        .where(
          (TdBranch b) => b.name.toLowerCase().startsWith(swLower),
        );
  }

  @override
  Future<TdCaller> tdCaller({String id}) async {
    final avatar = await _avatar();

    final List<dynamic> response = await _withDelay(json_callers.callers);
    final dynamic found = response.firstWhere(
      (dynamic e) => e['id'] == id,
      orElse: () => throw TdNotFoundException(
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
    final List<dynamic> response = await _withDelay(json_callers.callers);
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
      orElse: () => throw TdNotFoundException('no category for id: $id'),
    );
  }

  @override
  Future<Iterable<TdCategory>> tdCategories() async {
    final List<dynamic> response = await _withDelay(json_categories.categories);
    return response.map(
      (dynamic e) => TdCategory.fromJson(e),
    );
  }

  @override
  Future<TdSubcategory> tdSubcategory({String id}) async {
    final List<dynamic> response =
        await _withDelay(json_sub_categories.subcategories);
    final dynamic json = response.firstWhere(
      (dynamic e) => e['id'] == id,
      orElse: () => throw TdNotFoundException('no sub category for id: $id'),
    );

    return _subcategoryFromJson(json, await tdCategory(id: json['categoryId']));
  }

  @override
  Future<Iterable<TdSubcategory>> tdSubcategories({
    TdCategory tdCategory,
  }) async {
    final List<dynamic> response = await _withDelay(
      json_sub_categories.subcategories,
    );

    return response
        .where(
          (dynamic e) => e['categoryId'] == tdCategory.id,
        )
        .map((dynamic e) => _subcategoryFromJson(e, tdCategory));
  }

  TdSubcategory _subcategoryFromJson(
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
    final List<dynamic> response = await _withDelay(json_durations.durations);
    return response.map(
      (dynamic e) => TdDuration.fromJson(e),
    );
  }

  @override
  Future<TdDuration> tdDuration({String id}) async {
    return (await tdDurations()).firstWhere(
      (TdDuration e) => e.id == id,
      orElse: () =>
          throw TdNotFoundException('no incident duration for id: $id'),
    );
  }

  @override
  Future<TdOperator> tdOperator({String id}) async {
    return (await tdOperators(startsWith: '')).firstWhere(
      (TdOperator e) => e.id == id,
      orElse: () => throw TdNotFoundException('no operator for id: $id'),
    );
  }

  @override
  Future<Iterable<TdOperator>> tdOperators({
    @required String startsWith,
  }) async {
    final swLower = startsWith.toLowerCase();

    final avatar = await _avatar();
    final List<dynamic> response = await _withDelay(json_operators.operators);
    return response
        .where(
          (dynamic e) => e['name'].toLowerCase().startsWith(swLower),
        )
        .map(
          (dynamic e) => _tdOperatorFromJson(e, avatar),
        );
  }

  TdOperator _tdOperatorFromJson(
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
    return (await _withDelay(json_avatar.avatar))['black'];
  }

  @override
  Future<String> createTdIncident({
    @required String briefDescription,
    @required Settings settings,
    String request,
  }) {
    return Future.delayed(latency, () => (++_incidentNumber).toString());
  }

  Future<dynamic> _withDelay(dynamic content) async {
    return Future<dynamic>.delayed(
      latency,
      () => content,
    );
  }
}
