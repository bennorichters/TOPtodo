import 'package:equatable/equatable.dart';
import 'package:toptodo_data/toptodo_data.dart';

/// Base class for all events related to login
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

/// Event that trigger loading credentials
class CredentialsInit extends LoginEvent {
  const CredentialsInit();
}

/// Event that triggers deletion of locally saved credentials
class LogOut extends LoginEvent {
  const LogOut();
}

/// Event that toggles a flag related to saving credentials or not
class RememberToggle extends LoginEvent {
  /// Creates an instance of [RememberToggle]
  const RememberToggle(this.credentials);

  /// the credentials
  final Credentials credentials;

  @override
  List<Object> get props => [credentials];
}

/// Event that triggers an attempt to login
class TryLogin extends LoginEvent {
  /// Creates an instance of [TryLogin]
  const TryLogin(this.credentials);

  /// the credentials
  final Credentials credentials;

  @override
  List<Object> get props => [credentials];
}
