import 'package:equatable/equatable.dart';

abstract class IncidentEvent extends Equatable {
  const IncidentEvent();
}

class IncidentShowForm extends IncidentEvent {
  @override
  List<Object> get props => <Object>[];
}

class IncidentSubmit extends IncidentEvent {
  @override
  List<Object> get props => <Object>[];
}

class IncidentShowSettingsEvent extends IncidentEvent {
  @override
  List<Object> get props => <Object>[];
}

class IncidentLogOutEvent extends IncidentEvent {
  @override
  List<Object> get props => <Object>[];
}
