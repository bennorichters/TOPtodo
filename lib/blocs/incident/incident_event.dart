import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Base class for all events that can be added to the sink of [IncidentBloc]
abstract class IncidentEvent extends Equatable {
  const IncidentEvent();

  @override
  List<Object> get props => [];
}

/// Initializing event
class IncidentInit extends IncidentEvent {
  const IncidentInit();
}

/// Incident submit event
class IncidentSubmit extends IncidentEvent {
  const IncidentSubmit({
    @required this.briefDescription,
    @required this.request,
  });

  /// the brief description
  final String briefDescription;

  /// the request
  final String request;

  @override
  List<Object> get props => super.props
    ..addAll([
      briefDescription,
      request,
    ]);
}
