import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:toptodo_data/toptodo_data.dart';

abstract class IncidentState extends Equatable {
  const IncidentState();

  @override
  List<Object> get props => [];
}

class InitialIncidentState extends IncidentState {
  const InitialIncidentState();
}

abstract class WithOperatorState extends IncidentState {
  const WithOperatorState({@required this.currentOperator});
  final TdOperator currentOperator;

  @override
  List<Object> get props => super.props..addAll([currentOperator]);

  @override
  String toString() => '$runtimeType currentOperator: $currentOperator';
}

class OperatorLoaded extends WithOperatorState {
  const OperatorLoaded({@required TdOperator currentOperator})
      : super(currentOperator: currentOperator);
}

class SubmittingIncident extends WithOperatorState {
  const SubmittingIncident({@required TdOperator currentOperator})
      : super(currentOperator: currentOperator);
}

class IncidentCreated extends WithOperatorState {
  const IncidentCreated({
    @required this.number,
    @required TdOperator currentOperator,
  }) : super(currentOperator: currentOperator);

  final String number;

  @override
  List<Object> get props => super.props..addAll([number]);
}

class IncidentCreationError extends WithOperatorState {
  const IncidentCreationError({
    @required this.cause,
    @required TdOperator currentOperator,
  }) : super(currentOperator: currentOperator);

  final Object cause;

  @override
  List<Object> get props => super.props..addAll([cause]);
}
