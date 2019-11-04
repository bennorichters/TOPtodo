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
}
