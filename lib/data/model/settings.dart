import 'dart:convert';
import 'package:flutter/material.dart';

class Settings {
  final String branchId;
  final String callerId;
  final String categoryId;
  final String subcategoryId;
  final String durationId;
  final String operatorId;

  const Settings({
    @required this.branchId,
    @required this.callerId,
    @required this.categoryId,
    @required this.subcategoryId,
    @required this.durationId,
    @required this.operatorId,
  });

  Settings.fromJson(Map<String, dynamic> json)
      : branchId = json['branchId'],
        callerId = json['callerId'],
        categoryId = json['categoryId'],
        subcategoryId = json['subcategoryId'],
        durationId = json['durationId'],
        operatorId = json['operatorId'];

  Map<String, dynamic> toJson() => {
        'branchId': branchId,
        'callerId': callerId,
        'categoryId': categoryId,
        'subcategoryId': subcategoryId,
        'durationId': durationId,
        'operatorId': operatorId,
      };

  @override
  String toString() => jsonEncode(toJson());
}
