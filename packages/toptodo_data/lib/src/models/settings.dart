import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Settings extends Equatable {
  const Settings({
    @required this.branchId,
    @required this.callerId,
    @required this.categoryId,
    @required this.subCategoryId,
    @required this.incidentDurationId,
    @required this.incidentOperatorId,
  });

  Settings.fromJson(Map<String, dynamic> json)
      : branchId = json['branchId'],
        callerId = json['callerId'],
        categoryId = json['categoryId'],
        subCategoryId = json['subCategoryId'],
        incidentDurationId = json['incidentDurationId'],
        incidentOperatorId = json['incidentOperatorId'];

  const Settings.empty()
      : branchId = null,
        callerId = null,
        categoryId = null,
        subCategoryId = null,
        incidentDurationId = null,
        incidentOperatorId = null;

  final String branchId;
  final String callerId;
  final String categoryId;
  final String subCategoryId;
  final String incidentDurationId;
  final String incidentOperatorId;

  bool isComplete() =>
      branchId != null &&
      callerId != null &&
      categoryId != null &&
      subCategoryId != null &&
      incidentDurationId != null &&
      incidentOperatorId != null;

  Map<String, dynamic> toJson() => {
        'branchId': branchId,
        'callerId': callerId,
        'categoryId': categoryId,
        'subCategoryId': subCategoryId,
        'incidentDurationId': incidentDurationId,
        'incidentOperatorId': incidentOperatorId,
      };

  @override
  List<Object> get props => <Object>[
        branchId,
        callerId,
        categoryId,
        subCategoryId,
        incidentDurationId,
        incidentOperatorId,
      ];

  @override
  String toString() => toJson().toString();
}
