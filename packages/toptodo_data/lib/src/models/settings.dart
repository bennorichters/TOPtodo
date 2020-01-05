import 'package:equatable/equatable.dart';

class Settings extends Equatable {
  const Settings({
    this.branchId,
    this.callerId,
    this.categoryId,
    this.subCategoryId,
    this.incidentDurationId,
    this.incidentOperatorId,
  });

  Settings.fromJson(Map<String, dynamic> json)
      : branchId = json['branchId'],
        callerId = json['callerId'],
        categoryId = json['categoryId'],
        subCategoryId = json['subCategoryId'],
        incidentDurationId = json['incidentDurationId'],
        incidentOperatorId = json['incidentOperatorId'];

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
  String toString() => 'Settings [${toJson().toString()}]';
}
