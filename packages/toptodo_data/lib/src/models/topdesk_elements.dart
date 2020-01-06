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
class TdBranch extends TdModel {
  const TdBranch({
    @required String id,
    @required String name,
  }) : super(id: id, name: name);
}

/// A [TdModel] representing a duration in TOPdesk. 
class TdDuration extends TdModel {
  const TdDuration({
    @required String id,
    @required String name,
  }) : super(id: id, name: name);
}

/// A [TdModel] representing a category in TOPdesk
class TdCategory extends TdModel {
  const TdCategory({
    @required String id,
    @required String name,
  }) : super(id: id, name: name);
}

/// A [TdModel] representing a subcategory in TOPdesk. A subcategory has a 
/// parent [TdCategory] that cannot be `null`.
class TdSubcategory extends TdModel {
  const TdSubcategory({
    @required String id,
    @required String name,
    @required this.category,
  })  : assert(category != null),
        super(id: id, name: name);

  /// The category this sub category belongs to
  final TdCategory category;
}

/// A [TdModel] base class for TOPdesk models representing persons. A person
/// has an [avatar]. The `avatar` can be `null`.
abstract class TdPerson extends TdModel {
  const TdPerson({
    @required String id,
    @required String name,
    this.avatar,
  }) : super(id: id, name: name);

  /// Image information. See documentation of the implementing class for 
  /// details.
  final String avatar;
}

/// A [TdPerson] that represents a caller in TOPdesk. A caller has a parent 
/// [TdBranch] that cannot be null.
class TdCaller extends TdPerson {
  const TdCaller({
    @required String id,
    @required String name,
    String avatar,
    @required this.branch,
  })  : assert(branch != null),
        super(id: id, name: name, avatar: avatar);

  /// the branch this caller belongs to
  final TdBranch branch;
}

/// A [TdPerson] that represents an operator in TOPdesk. This class adds two 
/// fields, [firstLine] and [secondLine], representing if this operator can be
/// assigned to first and second line incidents repectively. Both these fields 
/// cannot be `null`. 
class TdOperator extends TdPerson {
  const TdOperator({
    @required String id,
    @required String name,
    String avatar,
    @required this.firstLine,
    @required this.secondLine,
  })  : assert(firstLine != null),
        assert(secondLine != null),
        super(id: id, name: name, avatar: avatar);

  /// flag to see if this operator can be assigned to first line incidents
  final bool firstLine;
  /// flag to see if this operator can be assigned to second line incidents
  final bool secondLine;
}
