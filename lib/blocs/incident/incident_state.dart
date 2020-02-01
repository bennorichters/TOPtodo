import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:toptodo_data/toptodo_data.dart';

class IncidentState extends Equatable {
  const IncidentState({@required this.currentOperator});
  final TdOperator currentOperator;

  @override
  List<Object> get props => [currentOperator];

  @override
  String toString() => '$runtimeType currentOperator: $currentOperator';
}

class SubmittingIncident extends IncidentState {
  const SubmittingIncident({@required TdOperator currentOperator})
      : super(currentOperator: currentOperator);
}

class IncidentCreated extends IncidentState {
  const IncidentCreated({
    @required this.number,
    @required TdOperator currentOperator,
  }) : super(currentOperator: currentOperator);

  final String number;

  @override
  List<Object> get props => super.props..addAll([number]);
}

class IncidentCreationError extends IncidentState {
  const IncidentCreationError({
    @required this.cause,
    @required TdOperator currentOperator,
  }) : super(currentOperator: currentOperator);

  final Object cause;

  @override
  List<Object> get props => super.props..addAll([cause]);
}
