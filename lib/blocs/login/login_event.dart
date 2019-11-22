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

class TryLogin extends LoginEvent {
  const TryLogin(this.credentials);
  final Credentials credentials;

  @override
  List<Object> get props => <Object>[credentials];
}

