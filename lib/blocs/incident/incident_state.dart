import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:toptodo_data/toptodo_data.dart';

/// State that holds a [TdOperator] as the current operator which can be `null`.
///
/// This is the base class for all other incident states.
class IncidentState extends Equatable {
  /// Creates an instance of [IncidentState]
  const IncidentState({@required this.currentOperator});

  /// the current operator
  final TdOperator currentOperator;

  @override
  List<Object> get props => [currentOperator];

  @override
  String toString() => '$runtimeType currentOperator: $currentOperator';
}

/// State that is emmitted directly after a request to create an incident has
/// been made, but before a result has been received.
class IncidentSubmitted extends IncidentState {
  /// Creates an instance of [IncidentSubmitted]
  const IncidentSubmitted({@required TdOperator currentOperator})
      : super(currentOperator: currentOperator);
}

/// State that is emitted after a new incident number has been received
/// following an incident creating request.
class IncidentCreated extends IncidentState {
  /// Creates an instance of [IncidentCreated]
  const IncidentCreated({
    @required this.number,
    @required TdOperator currentOperator,
  }) : super(currentOperator: currentOperator);

  /// the new incident number
  final String number;

  @override
  List<Object> get props => super.props..addAll([number]);
}

/// State that is emitted when an incident creating request resulted in an
/// error.
class IncidentCreationError extends IncidentState {
  const IncidentCreationError({
    @required this.cause,
    @required this.stackTrace,
    @required TdOperator currentOperator,
  }) : super(currentOperator: currentOperator);

  /// the cause of the error
  final Object cause;

  /// the stack trace at the moment the error occured
  final StackTrace stackTrace;

  @override
  List<Object> get props => super.props..addAll([cause]);
}
