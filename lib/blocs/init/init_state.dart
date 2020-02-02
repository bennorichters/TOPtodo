import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:toptodo_data/toptodo_data.dart';

/// Base class for all states related to initialization of TOPtodo
abstract class InitState extends Equatable {
  const InitState();
}

/// State emmitted
class InitData extends InitState {
  const InitData({
    @required this.credentials,
    this.currentOperator,
    this.settings,
  });

  const InitData.empty()
      : credentials = null,
        currentOperator = null,
        settings = null;

  final Credentials credentials;
  final TdOperator currentOperator;
  final Settings settings;

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

  bool isReady() =>
      credentials != null && currentOperator != null && settings != null;

  bool isCredentialsComplete() =>
      credentials != null && credentials.isComplete();

  bool isSettingssComplete() => settings != null && settings.isComplete();

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
