import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:toptodo_data/toptodo_data.dart';

abstract class IncidentState extends Equatable {
  const IncidentState();
}

class InitialIncidentState extends IncidentState {
  const InitialIncidentState();

  @override
  List<Object> get props => [];
}

abstract class WithOperatorState extends IncidentState {
  const WithOperatorState({@required this.currentOperator});
  final IncidentOperator currentOperator;

  @override
  List<Object> get props => [currentOperator];
}

class OperatorLoaded extends WithOperatorState {
  const OperatorLoaded({@required IncidentOperator currentOperator})
      : super(currentOperator: currentOperator);

  @override
  List<Object> get props => [];
}

class SubmittingIncident extends WithOperatorState {
  const SubmittingIncident({@required IncidentOperator currentOperator})
      : super(currentOperator: currentOperator);

  @override
  List<Object> get props => [];
}

class IncidentCreated extends WithOperatorState {
  const IncidentCreated({
    @required this.number,
    @required IncidentOperator currentOperator,
  }) : super(currentOperator: currentOperator);

  final String number;

  @override
  List<Object> get props => [number];
}

class IncidentCreationError extends WithOperatorState {
  const IncidentCreationError({
    @required this.cause,
    @required IncidentOperator currentOperator,
  }) : super(currentOperator: currentOperator);

  final Object cause;

  @override
  List<Object> get props => [cause];
}
