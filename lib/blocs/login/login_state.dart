import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:toptodo_data/toptodo_data.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginWaitingForSavedData extends LoginState {
  const LoginWaitingForSavedData();

  @override
  List<Object> get props => <Object>[];
}

abstract class WithSavedData extends LoginState {
  const WithSavedData(this.savedData, this.remember);
  final Credentials savedData;
  final bool remember;

  @override
  List<Object> get props => <Object>[remember, savedData];
}

class RetrievedSavedData extends WithSavedData {
  const RetrievedSavedData(Credentials savedData, bool remember)
      : super(savedData, remember);
}

class LoginSubmitting extends LoginState {
  const LoginSubmitting();

  @override
  List<Object> get props => <Object>[];
}

class LoginSuccessIncompleteSettings extends LoginState {
  const LoginSuccessIncompleteSettings({
    @required this.topdeskProvider,
    @required this.settings,
  });

  final TopdeskProvider topdeskProvider;
  final Settings settings;

  @override
  List<Object> get props => <Object>[topdeskProvider, settings];
}

class LoginSuccessValidSettings extends LoginState {
  const LoginSuccessValidSettings({
    @required this.topdeskProvider,
    @required this.settings,
  });

  final TopdeskProvider topdeskProvider;
  final Settings settings;

  @override
  List<Object> get props => <Object>[topdeskProvider, settings];
}

class LoginFailed extends WithSavedData {
  const LoginFailed({
    @required Credentials savedData,
    @required bool remember,
    @required this.cause,
  }) : super(savedData, remember);
  final Exception cause;

  @override
  List<Object> get props => <Object>[cause];
}
