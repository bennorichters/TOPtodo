import 'dart:convert';
import 'package:meta/meta.dart';

class Settings {
  const Settings({
    @required this.branchId,
    @required this.callerId,
    @required this.categoryId,
    @required this.subcategoryId,
    @required this.incidentDurationId,
    @required this.incidentOperatorId,
  });

  Settings.fromJson(Map<String, dynamic> json)
      : branchId = json['branchId'],
        callerId = json['callerId'],
        categoryId = json['categoryId'],
        subcategoryId = json['subcategoryId'],
        incidentDurationId = json['incidentDurationId'],
        incidentOperatorId = json['incidentOperatorId'];

  final String branchId;
  final String callerId;
  final String categoryId;
  final String subcategoryId;
  final String incidentDurationId;
  final String incidentOperatorId;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'branchId': branchId,
        'callerId': callerId,
        'categoryId': categoryId,
        'subcategoryId': subcategoryId,
        'incidentDurationId': incidentDurationId,
        'incidentOperatorId': incidentOperatorId,
      };

  @override
  String toString() => jsonEncode(toJson());
}
