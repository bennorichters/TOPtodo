import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Base class for all TOPdesk models. It has an [id] and a [name]. Some
/// subclasses add additional fields.
/// 
/// Two TOPdesk models are considered equal if there `runtimeType` is equal and
/// their `id` is equal. The `id` and `name` cannot be `null`. Instances of 
/// this class and its subclasses are immutable.
abstract class TdModel extends Equatable {
  const TdModel({
    @required this.id,
    @required this.name,
  })  : assert(id != null),
        assert(name != null);

  /// unique identifier
  final String id;
  /// name 
  final String name;

  @override
  List<Object> get props => [id];

  @override
  String toString() => name;
}

/// A [TdModel] representing a branch in TOPdesk
class Branch extends TdModel {
  const Branch({
    @required String id,
    @required String name,
  }) : super(id: id, name: name);
}

/// A [TdModel] representing a duration in TOPdesk. The name of this type is 
/// prefixed with the word 'incident' to avoid conflicts with the Dart type 
/// `Duration`.
class IncidentDuration extends TdModel {
  const IncidentDuration({
    @required String id,
    @required String name,
  }) : super(id: id, name: name);
}

/// A [TdModel] representing a category in TOPdesk
class Category extends TdModel {
  const Category({
    @required String id,
    @required String name,
  }) : super(id: id, name: name);
}

/// A [TdModel] representing a sub category in TOPdesk. A sub category has a 
/// parent [Category] that cannot be `null`.
class SubCategory extends TdModel {
  const SubCategory({
    @required String id,
    @required String name,
    @required this.category,
  })  : assert(category != null),
        super(id: id, name: name);

  final Category category;
}

/// A [TdModel] base class for TOPdesk models representing persons. A person
/// has an [avatar]. The `avatar` can be `null`.
abstract class Person extends TdModel {
  const Person({
    @required String id,
    @required String name,
    this.avatar,
  }) : super(id: id, name: name);

  final String avatar;
}

/// A [Person] that represents a caller in TOPdesk. A caller has a parent 
/// [Branch] that cannot be null.
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

/// A [Person] that represents an operator in TOPdesk. The name of this type is 
/// prefixed with the word 'incident' to avoid conflicts with the reserved word
/// 'operator' in Dart. This class adds to fields, [firstLine] and 
/// [secondLine], representing if this operator can be assigned to first and 
/// second line incidents repectively. Both these fields cannot be `null`. 
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
