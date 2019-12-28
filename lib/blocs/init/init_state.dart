import 'package:equatable/equatable.dart';
import 'package:toptodo_data/toptodo_data.dart';

abstract class InitState extends Equatable {
  const InitState();
}

class InitData extends InitState {
  const InitData({
    this.credentials,
    this.currentOperator,
    this.settings,
  });

  const InitData.empty()
      : credentials = null,
        currentOperator = null,
        settings = null;

  final Credentials credentials;
  final IncidentOperator currentOperator;
  final Settings settings;

  InitData update({
    Credentials updatedCredentials,
    IncidentOperator updatedCurrentOperator,
    Settings updatedSettings,
  }) =>
      InitData(
        credentials: updatedCredentials ?? credentials,
        currentOperator: updatedCurrentOperator ?? currentOperator,
        settings: updatedSettings ?? settings,
      );

  bool isComplete() =>
      credentials != null && currentOperator != null && settings != null;

  @override
  List<Object> get props => [credentials, currentOperator, settings];

  @override
  String toString() => 'LoadingInitData - '
      'credentials: $credentials, '
      'currentOperator: $currentOperator, '
      'settings: $settings';
}

class IncompleteCredentials extends InitState {
  const IncompleteCredentials(this.credentials);
  final Credentials credentials;

  @override
  List<Object> get props => [credentials];

  @override
  String toString() => 'IncompleteCredentials - '
      'credentials: $credentials';
}
