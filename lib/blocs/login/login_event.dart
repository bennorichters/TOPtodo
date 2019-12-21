import 'package:equatable/equatable.dart';
import 'package:toptodo_data/toptodo_data.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class AppStarted extends LoginEvent {
  const AppStarted();

  @override
  List<Object> get props => <Object>[];
}

class RememberToggle extends LoginEvent {
  const RememberToggle(this.credentials, this.remember);
  final Credentials credentials;
  final bool remember;

  @override
  List<Object> get props => <Object>[credentials, remember];
}

class TryLogin extends LoginEvent {
  const TryLogin(this.credentials);
  final Credentials credentials;

  @override
  List<Object> get props => <Object>[credentials];
}