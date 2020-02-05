import 'package:equatable/equatable.dart';

/// A 'pojo' for the settings of a user.
///
/// A container for several elements that are used to create an incident. Each
/// element contains a foreign key that refers to a [TdModel].
///
/// Instances of this class are considered equal if and only if all matching
/// fields of both instances are equal. All fields can be null. Instances of
/// this class are immutable.
class Settings extends Equatable {
  /// Creates an instance of `Settings`
  const Settings({
    this.tdBranchId,
    this.tdCallerId,
    this.tdCategoryId,
    this.tdSubcategoryId,
    this.tdDurationId,
    this.tdOperatorId,
  });

  /// Converts a json object into an instance of `Settings`
  Settings.fromJson(Map<String, dynamic> json)
      : tdBranchId = json['tdBranchId'],
        tdCallerId = json['tdCallerId'],
        tdCategoryId = json['tdCategoryId'],
        tdSubcategoryId = json['tdSubcategoryId'],
        tdDurationId = json['tdDurationId'],
        tdOperatorId = json['tdOperatorId'];

  /// foreign key to a [TdBranch]
  final String tdBranchId;

  /// foreign key to a [TdCaller]
  final String tdCallerId;

  /// foreign key to a [TdCategory]
  final String tdCategoryId;

  /// foreign key to a [TdSubcategory]
  final String tdSubcategoryId;

  /// foreign key to a [TdDuration]
  final String tdDurationId;

  /// foreign key to a [TdOperator]
  final String tdOperatorId;

  /// Returns  `true` if none of the fields are null, `false` otherwise.
  bool isComplete() => !props.contains(null);

  /// Converts this instance to a json object
  Map<String, dynamic> toJson() => {
        'tdBranchId': tdBranchId,
        'tdCallerId': tdCallerId,
        'tdCategoryId': tdCategoryId,
        'tdSubcategoryId': tdSubcategoryId,
        'tdDurationId': tdDurationId,
        'tdOperatorId': tdOperatorId,
      };

  @override
  List<Object> get props => [
        tdBranchId,
        tdCallerId,
        tdCategoryId,
        tdSubcategoryId,
        tdDurationId,
        tdOperatorId,
      ];

  @override
  String toString() => 'Settings [${toJson().toString()}]';
}
