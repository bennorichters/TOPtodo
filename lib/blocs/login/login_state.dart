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
class AwaitingCredentials extends LoginState {
  /// Creates an instance of [AwaitingCredentials]
  const AwaitingCredentials();
}

/// Base class for all state objects related to login with
/// credential data
abstract class WithCredentials extends LoginState {
  const WithCredentials(this.credentials, this.remember);
  final Credentials credentials;
  final bool remember;

  @override
  List<Object> get props => super.props..addAll([remember, credentials]);

  @override
  String toString() => '$runtimeType: '
      'credentials: $credentials, '
      'remember: $remember';
}

/// State emitted when the credentials have been loaded
class RetrievedCredentials extends WithCredentials {
  /// Creates an incidents of [RetrievedCredentials]
  const RetrievedCredentials(Credentials credentials, bool remember)
      : super(credentials, remember);
}

/// State emitted when a login request is sent
class LoginSubmitting extends LoginState {
  /// Creates an instance of [LoginSubmitting]
  const LoginSubmitting();

  @override
  List<Object> get props => <Object>[];
}

/// State emitted when login was successful
class LoginSuccess extends LoginState {
  /// Creates an instance of [LoginSuccess]
  const LoginSuccess({
    @required this.topdeskProvider,
    @required this.settings,
  });

  /// The topdesk provider
  final TopdeskProvider topdeskProvider;

  /// The settings
  final Settings settings;

  @override
  List<Object> get props => super.props..addAll([topdeskProvider, settings]);
}

/// Emittes when logging in faild
class LoginFailed extends WithCredentials {
  /// Creates an instance of [LoginFailed]
  const LoginFailed({
    @required Credentials savedData,
    @required bool remember,
    @required this.cause,
    @required this.stackTrace,
  }) : super(savedData, remember);

  /// The cause of the exception that lead to the emission of this state
  final Object cause;

  /// The stack trace at the moment the exception was thrown and that lead to
  /// the emission of this state
  final StackTrace stackTrace;

  @override
  List<Object> get props => super.props..addAll([cause]);
}
