import 'package:equatable/equatable.dart';

abstract class TdModel extends Equatable {
  const TdModel(this.id, this.name)
      : assert(id != null),
        assert(name != null);

  final String id;
  final String name;

  @override
  List<Object> get props => <Object>[id];

  @override
  String toString() => name;
}

class Branch extends TdModel {
  const Branch(String id, String name) : super(id, name);
}

class IncidentDuration extends TdModel {
  const IncidentDuration(String id, String name) : super(id, name);
}

class Category extends TdModel {
  const Category(String id, String name) : super(id, name);
}

class SubCategory extends TdModel {
  const SubCategory(String id, String name, this.category)
      : assert(category != null),
        super(id, name);

  final Category category;
}

abstract class Person extends TdModel {
  const Person(String id, String name, this.avatar)
      : assert(avatar != null),
        super(id, name);

  final String avatar;
}

class Caller extends Person {
  const Caller(String id, String name, String avatar, this.branch)
      : assert(branch != null),
        super(id, name, avatar);

  final Branch branch;
}

class IncidentOperator extends Person {
  const IncidentOperator(String id, String name, String avatar)
      : super(id, name, avatar);
}
