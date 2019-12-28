import 'package:equatable/equatable.dart';
import 'package:toptodo_data/toptodo_data.dart';

abstract class InitState extends Equatable {
  const InitState();
}

class LoadingInitData extends InitState {
  const LoadingInitData({
    this.credentials,
    this.currentOperator,
    this.settings,
  });

  const LoadingInitData.empty()
      : credentials = null,
        currentOperator = null,
        settings = null;

  final Credentials credentials;
  final IncidentOperator currentOperator;
  final Settings settings;

  @override
  List<Object> get props => [credentials, currentOperator, settings];
}
