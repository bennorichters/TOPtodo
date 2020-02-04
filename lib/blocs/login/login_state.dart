import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:toptodo_data/toptodo_data.dart';

/// Base class for all state objects related to login
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => <Object>[];
}

/// State emitted when the login bloc requested the credential
/// data and is waiting for it
class LoginWaitingForSavedData extends LoginState {
  const LoginWaitingForSavedData();
}

/// Base class for all state objects related to login with 
/// credential data
abstract class WithSavedData extends LoginState {
  const WithSavedData(this.savedData, this.remember);
  final Credentials savedData;
  final bool remember;

  @override
  List<Object> get props => super.props..addAll([remember, savedData]);

  @override
  String toString() => '$runtimeType: '
      'credentials: $savedData, '
      'remember: $remember';
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

class LoginSuccess extends LoginState {
  const LoginSuccess({
    @required this.topdeskProvider,
    @required this.settings,
  });

  final TopdeskProvider topdeskProvider;
  final Settings settings;

  @override
  List<Object> get props => super.props..addAll([topdeskProvider, settings]);
}

class LoginFailed extends WithSavedData {
  const LoginFailed({
    @required Credentials savedData,
    @required bool remember,
    @required this.cause,
    @required this.stackTrace,
  }) : super(savedData, remember);

  final Object cause;
  final StackTrace stackTrace;

  @override
  List<Object> get props => super.props..addAll([cause]);
}
