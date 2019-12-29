import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:toptodo_data/toptodo_data.dart';

abstract class IncidentState extends Equatable {
  const IncidentState();
}

class InitialIncidentState extends IncidentState {
  @override
  List<Object> get props => [];
}

abstract class WithOperatorState extends IncidentState {
  WithOperatorState({@required this.currentOperator});
  final IncidentOperator currentOperator;

  @override
  List<Object> get props => [currentOperator];
}

class OperatorLoaded extends WithOperatorState {
  OperatorLoaded({@required IncidentOperator currentOperator})
      : super(currentOperator: currentOperator);

  @override
  List<Object> get props => [];
}

class SubmittingIncident extends WithOperatorState {
  SubmittingIncident({@required IncidentOperator currentOperator})
      : super(currentOperator: currentOperator);

  @override
  List<Object> get props => [];
}

class IncidentCreated extends WithOperatorState {
  IncidentCreated({
    @required this.number,
    @required IncidentOperator currentOperator,
  }) : super(currentOperator: currentOperator);

  final String number;

  @override
  List<Object> get props => [number];
}

class IncidentCreationError extends WithOperatorState {
  IncidentCreationError({
    @required this.cause,
    @required IncidentOperator currentOperator,
  }) : super(currentOperator: currentOperator);

  final Exception cause;

  @override
  List<Object> get props => [cause];
}
