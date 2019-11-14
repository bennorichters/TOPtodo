import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class IncidentDuration extends Equatable {
  const IncidentDuration({
    @required this.id,
    @required this.name,
  });

  IncidentDuration.fromMappedJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  final String id;
  final String name;

  @override
  List<Object> get props => <Object> [id];

  @override
  String toString() => name;
}

class Branch extends Equatable {
  const Branch({
    @required this.id,
    @required this.name,
  });

  Branch.fromMappedJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  final String id;
  final String name;

  @override
  List<Object> get props => <Object> [id];

  @override
  String toString() => name;
}
