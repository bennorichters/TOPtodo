import 'package:equatable/equatable.dart';

abstract class IdNameModel extends Equatable {
  IdNameModel.fromJson(Map<String, dynamic> json)
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
  IncidentDuration.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

class Branch extends IdNameModel {
  Branch.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

class Person extends IdNameModel {
  Person.fromJson(Map<String, dynamic> json)
      : branchid = json['branchid'],
        super.fromJson(json);

  final String branchid;
}
