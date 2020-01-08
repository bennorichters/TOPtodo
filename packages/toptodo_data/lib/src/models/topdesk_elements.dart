import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Base class for all TOPdesk models. It has an [id] and a [name]. Some
/// subclasses add additional fields.
///
/// Two TOPdesk models are considered equal if there `runtimeType` is equal and
/// their `id` is equal. The `id` and `name` cannot be `null`. Instances of
/// this class and its subclasses are immutable.
abstract class TdModel extends Equatable {
  /// Abstract constructor for a `TdModel`
  const TdModel({
    @required this.id,
    @required this.name,
  })  : assert(id != null),
        assert(name != null);

  /// Abstract constructor for a `TdModel`
  TdModel.fromJson(Map<String, dynamic> json)
      : this(id: json['id'], name: json['name']);

  /// A unique identifier for this `TdModel`
  final String id;

  /// The name of this `TdModel`
  final String name;

  @override
  List<Object> get props => [id];

  @override
  String toString() => name;
}

/// A [TdModel] representing a branch in TOPdesk
class TdBranch extends TdModel {
  /// Creates a new instance of a `TdBranch`
  const TdBranch({
    @required String id,
    @required String name,
  }) : super(id: id, name: name);

  /// Creates a new instance of a `TdBranch`
  TdBranch.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

/// A [TdModel] representing a duration in TOPdesk.
class TdDuration extends TdModel {
  /// Creates a new instance of a `TdDuration`
  const TdDuration({
    @required String id,
    @required String name,
  }) : super(id: id, name: name);

  /// Creates a new instance of a `TdDuration`
  TdDuration.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

/// A [TdModel] representing a category in TOPdesk
class TdCategory extends TdModel {
  /// Creates a new instance of a `TdCategory`
  const TdCategory({
    @required String id,
    @required String name,
  }) : super(id: id, name: name);

  /// Creates a new instance of a `TdCategory`
  TdCategory.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

/// A [TdModel] representing a subcategory in TOPdesk. A subcategory has a
/// parent [TdCategory] that cannot be `null`.
class TdSubcategory extends TdModel {
  /// Creates a new instance of a `TdSubcategory`
  const TdSubcategory({
    @required String id,
    @required String name,
    @required this.category,
  })  : assert(category != null),
        super(id: id, name: name);

  /// Creates a new instance of a `TdSubcategory`
  TdSubcategory.fromJson(Map<String, dynamic> json)
      : category = TdCategory.fromJson(json['category']),
        super.fromJson(json);

  /// The category this subcategory belongs to
  final TdCategory category;
}

/// A [TdModel] base class for TOPdesk models representing persons. A person
/// has an [avatar]. The `avatar` can be `null`.
abstract class TdPerson extends TdModel {
  /// Abstract constructor for `TdPerson`
  const TdPerson({
    @required String id,
    @required String name,
    this.avatar,
  }) : super(id: id, name: name);

  /// Abstract constructor for `TdPerson`
  TdPerson.fromJson(Map<String, dynamic> json)
      : avatar = json['avatar'],
        super.fromJson(json);

  /// Image information. See documentation of the implementing class for
  /// details.
  final String avatar;
}

/// A [TdPerson] that represents a caller in TOPdesk. A caller has a parent
/// [TdBranch] that cannot be null.
class TdCaller extends TdPerson {
  /// Creates a new instance of a `TdCaller`
  const TdCaller({
    @required String id,
    @required String name,
    String avatar,
    @required this.branch,
  })  : assert(branch != null),
        super(id: id, name: name, avatar: avatar);

  /// Creates a new instance of a `TdCaller`
  TdCaller.fromJson(Map<String, dynamic> json)
      : branch = TdBranch.fromJson(json['branch']),
        super.fromJson(json);

  /// the branch this caller belongs to
  final TdBranch branch;
}

/// A [TdPerson] that represents an operator in TOPdesk. This class adds two
/// fields, [firstLine] and [secondLine], representing if this operator can be
/// assigned to first and second line incidents repectively. Both these fields
/// cannot be `null`.
class TdOperator extends TdPerson {
  /// Creates a new instance of a `TdOperator`
  const TdOperator({
    @required String id,
    @required String name,
    String avatar,
    @required this.firstLine,
    @required this.secondLine,
  })  : assert(firstLine != null),
        assert(secondLine != null),
        super(id: id, name: name, avatar: avatar);

  /// Creates a new instance of a `TdOperator`
  TdOperator.fromJson(Map<String, dynamic> json)
      : assert(json['firstLineCallOperator'] is bool),
        assert(json['secondLineCallOperator'] is bool),
        firstLine = json['firstLineCallOperator'],
        secondLine = json['secondLineCallOperator'],
        super.fromJson(json);

  /// flag to see if this operator can be assigned to first line incidents
  final bool firstLine;

  /// flag to see if this operator can be assigned to second line incidents
  final bool secondLine;
}
