import 'package:equatable/equatable.dart';

abstract class IncidentState extends Equatable {
  const IncidentState();
}

class InitialIncidentState extends IncidentState {
  @override
  List<Object> get props => [];
}

class SubmittingIncident extends IncidentState {
  @override
  List<Object> get props => [];
}

class IncidentCreated extends IncidentState {
  IncidentCreated(this.number);
  final String number;

  @override
  List<Object> get props => [number];
}
