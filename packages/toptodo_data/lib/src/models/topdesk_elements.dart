import 'package:equatable/equatable.dart';

abstract class IdNameModel extends Equatable {
  IdNameModel.fromMappedJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  final String id;
  final String name;

  @override
  List<Object> get props => <Object>[id];

  @override
  String toString() => name;
}

class IncidentDuration extends IdNameModel {
  IncidentDuration.fromMappedJson(Map<String, dynamic> json)
      : super.fromMappedJson(json);
}

class Branch extends IdNameModel {
  Branch.fromMappedJson(Map<String, dynamic> json) : super.fromMappedJson(json);
}

class Person extends IdNameModel {
  Person.fromMappedJson(Map<String, dynamic> json)
      : branchid = json['branchid'],
        super.fromMappedJson(json);

  final String branchid;
}
