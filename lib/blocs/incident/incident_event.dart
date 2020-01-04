import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class IncidentEvent extends Equatable {
  const IncidentEvent();
}

class IncidentShowForm extends IncidentEvent {
  const IncidentShowForm();

  @override
  List<Object> get props => [];
}

class IncidentSubmit extends IncidentEvent {
  const IncidentSubmit({
    @required this.briefDescription,
    @required this.request,
  });
  final String briefDescription;
  final String request;

  @override
  List<Object> get props => [briefDescription, request];
}
