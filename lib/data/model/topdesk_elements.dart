import 'package:flutter/material.dart';

class IncidentDuration {
  final String id;
  final String name;

  IncidentDuration({
    @required this.id,
    @required this.name,
  });

  IncidentDuration.fromMappedJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  @override
  String toString() => name;
}
