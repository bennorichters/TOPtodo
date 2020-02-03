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

  /// `true` if none of the fields are null, `false` otherwise
  bool get isReady =>
      credentials != null && currentOperator != null && settings != null;

  bool get isCredentialsComplete =>
      credentials != null && credentials.isComplete;

  bool get isSettingssComplete => settings != null && settings.isComplete;

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

class LoadingDataFailed extends InitState {
  const LoadingDataFailed(this.cause, this.stackTrace);
  final Object cause;
  final StackTrace stackTrace;

  @override
  List<Object> get props => [cause];
}
