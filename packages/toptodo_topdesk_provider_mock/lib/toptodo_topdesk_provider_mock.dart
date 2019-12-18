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
          (dynamic e) => Branch.fromJson(e),
        )
        .where(
          (Branch b) => b.name.toLowerCase().startsWith(swLower),
        );
  }

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
    final List<dynamic> response = await _readJson('callers');
    return response
        .where(
      (dynamic e) =>
          (e['branchId'] == branch.id) &&
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
      (dynamic e) => Category.fromJson(e),
    );
  }

  @override
  Future<SubCategory> subCategory({String id}) async {
    final List<dynamic> response = await _readJson('sub_categories');
    final dynamic json = response.firstWhere(
      (dynamic e) => e['id'] == id,
      orElse: () =>
          throw TdModelNotFoundException('no sub category for id: $id'),
    );

    return SubCategory.fromJson(json);
  }

  @override
  Future<Iterable<SubCategory>> subCategories({Category category}) async {
    final List<dynamic> response = await _readJson('sub_categories');
    return response
        .where(
          (dynamic e) => e['categoryId'] == category.id,
        )
        .map(
          (dynamic e) => SubCategory.fromJson(e),
        );
  }

  @override
  Future<Iterable<IncidentDuration>> incidentDurations() async {
    final List<dynamic> response = await _readJson('durations');
    return response.map(
      (dynamic e) => IncidentDuration.fromJson(e),
    );
  }

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
      (dynamic e) {
        e['avatar'] = avatar;
        return IncidentOperator.fromJson(e);
      },
    );
  }

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
