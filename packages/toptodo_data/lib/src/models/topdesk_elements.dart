import 'package:equatable/equatable.dart';

abstract class TdModel extends Equatable {
  const TdModel(this.id, this.name);
  TdModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  final String id;
  final String name;

  @override
  List<Object> get props => <Object>[id];

  @override
  String toString() => name;
}

class Branch extends TdModel {
  Branch.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

class IncidentDuration extends TdModel {
  IncidentDuration.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

class Category extends TdModel {
  Category.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

class SubCategory extends TdModel {
  SubCategory.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

abstract class Person extends TdModel {
  Person.fromJson(Map<String, dynamic> json)
      : avatar = json['avatar'],
        super.fromJson(json);

  final String avatar;
}

class IncidentOperator extends Person {
  IncidentOperator.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

class Caller extends Person {
  Caller.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}
