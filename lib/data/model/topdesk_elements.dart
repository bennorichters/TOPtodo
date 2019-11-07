import 'package:flutter/material.dart';

class IncidentDuration {
  final String id;
  final String name;
  IncidentDuration({
    @required this.id,
    @required this.name,
  });

  @override
  String toString() => name;
}
