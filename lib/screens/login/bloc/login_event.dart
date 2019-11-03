import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class AppStarted extends LoginEvent {
  const AppStarted();

  @override
  List<Object> get props => [];
}

class TryLogin extends LoginEvent {
  const TryLogin();

  @override
  List<Object> get props => [];
}
