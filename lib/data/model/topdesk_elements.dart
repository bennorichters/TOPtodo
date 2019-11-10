import 'package:flutter/material.dart';

class IncidentDuration {
  IncidentDuration({
    @required this.id,
    @required this.name,
  });

  IncidentDuration.fromMappedJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  final String id;
  final String name;

  @override
  String toString() => name;
}
