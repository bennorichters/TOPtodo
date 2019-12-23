import 'package:equatable/equatable.dart';

abstract class IncidentState extends Equatable {
  const IncidentState();
}

class InitialIncidentState extends IncidentState {
  @override

  List<Object> get props => [];
}
