import 'package:equatable/equatable.dart';

abstract class IncidentState extends Equatable {
  const IncidentState();
}

class InitialIncidentState extends IncidentState {
  @override

  List<Object> get props => <Object>[];
}

class IncidentShowSettingsState extends IncidentState {
  @override
  List<Object> get props => <Object>[];
}

class IncidentLogOutState extends IncidentState {
  @override
  List<Object> get props => <Object>[];
}
