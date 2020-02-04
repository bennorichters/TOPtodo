import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:toptodo_data/toptodo_data.dart';

/// Base class for all states related to initialization of TOPtodo
abstract class InitState extends Equatable {
  const InitState();
}

/// State emmitted with the data needed to start the application.
class InitData extends InitState {
  const InitData({
    @required this.credentials,
    this.currentOperator,
    this.settings,
  });

  /// Creates a new instance of [InitData] where the credentials, the current
  /// operator and the settings are `null`.
  const InitData.empty()
      : credentials = null,
        currentOperator = null,
        settings = null;

  /// The credentials. This can be `null`.
  final Credentials credentials;

  /// The current operator. This can be `null`.
  final TdOperator currentOperator;

  /// The Settings. This can be `null`.
  final Settings settings;

  /// `true` if [credentials] is not `null` and is complete, `false` otherwise
  bool get hasCompleteCredentials =>
      (credentials != null) && credentials.isComplete;

  /// `true` if [credentials] is not `null` and is not complete, `false`
  /// otherwise
  bool get hasIncompleteCredentials =>
      (credentials != null) && !credentials.isComplete;

  /// `true` if [settings] is not `null` and is complete, `false` otherwise
  bool get hasCompleteSettings => (settings != null) && settings.isComplete;

  /// `true` if [settings] is not `null` and is not complete, `false` otherwise
  bool get hasIncompleteSettings => (settings != null) && !settings.isComplete;

  /// `true` if none of [credentials], [currentOperator] and [settings] are
  /// `null`, `false` otherwise
  bool get isReady =>
      credentials != null && currentOperator != null && settings != null;

  /// Returns a new instance of [InitData] with the given parameters if they are
  /// not `null`. Otherwise the new instance copies the fields from `this`
  /// instance.
  InitData update({
    Credentials updatedCredentials,
    TdOperator updatedCurrentOperator,
    Settings updatedSettings,
  }) =>
      InitData(
        credentials: updatedCredentials ?? credentials,
        currentOperator: updatedCurrentOperator ?? currentOperator,
        settings: updatedSettings ?? settings,
      );

  @override
  List<Object> get props => [credentials, currentOperator, settings];

  @override
  String toString() => 'LoadingInitData - '
      'credentials: $credentials, '
      'currentOperator: $currentOperator, '
      'settings: $settings';
}

/// State that is emitted when the initialization data could not be loaded.
class LoadingDataFailed extends InitState {
  /// Creates a new instance of [LoadingDataFailed]
  const LoadingDataFailed(this.cause, this.stackTrace);

  /// The cause of the exception that lead to the emission of this state
  final Object cause;

  /// The stack trace at the moment the exception was thrown and that lead to
  /// the emission of this state
  final StackTrace stackTrace;

  @override
  List<Object> get props => [cause];
}
