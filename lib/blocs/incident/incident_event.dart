import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class IncidentEvent extends Equatable {
  const IncidentEvent();
}

class IncidentShowForm extends IncidentEvent {
  @override
  List<Object> get props => <Object>[];
}

class IncidentSubmit extends IncidentEvent {
  IncidentSubmit({@required this.briefDescription, @required this.request});
  final String briefDescription;
  final String request;

  @override
  List<Object> get props => [briefDescription, request];
}
