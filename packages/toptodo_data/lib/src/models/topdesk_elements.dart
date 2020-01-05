import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class TdModel extends Equatable {
  const TdModel({
    @required this.id,
    @required this.name,
  })  : assert(id != null),
        assert(name != null);

  final String id;
  final String name;

  @override
  List<Object> get props => <Object>[id];

  @override
  String toString() => name;
}

class Branch extends TdModel {
  const Branch({
    @required String id,
    @required String name,
  }) : super(id: id, name: name);
}

class IncidentDuration extends TdModel {
  const IncidentDuration({
    @required String id,
    @required String name,
  }) : super(id: id, name: name);
}

class Category extends TdModel {
  const Category({
    @required String id,
    @required String name,
  }) : super(id: id, name: name);
}

class SubCategory extends TdModel {
  const SubCategory({
    @required String id,
    @required String name,
    @required this.category,
  })  : assert(category != null),
        super(id: id, name: name);

  final Category category;
}

abstract class Person extends TdModel {
  const Person({
    @required String id,
    @required String name,
    this.avatar,
  }) : super(id: id, name: name);

  final String avatar;
}

class Caller extends Person {
  const Caller({
    @required String id,
    @required String name,
    String avatar,
    @required this.branch,
  })  : assert(branch != null),
        super(id: id, name: name, avatar: avatar);

  final Branch branch;
}

class IncidentOperator extends Person {
  const IncidentOperator({
    @required String id,
    @required String name,
    String avatar,
    @required this.firstLine,
    @required this.secondLine,
  })  : assert(firstLine != null),
        assert(secondLine != null),
        super(id: id, name: name, avatar: avatar);

  final bool firstLine;
  final bool secondLine;
}
