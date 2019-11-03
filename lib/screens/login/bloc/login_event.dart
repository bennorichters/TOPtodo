import 'package:equatable/equatable.dart';
import 'package:toptopdo/data/model/credentials.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class AppStarted extends LoginEvent {
  const AppStarted();

  @override
  List<Object> get props => [];
}

class TryLogin extends LoginEvent {
  final Credentials credentials;
  const TryLogin(this.credentials);

  @override
  List<Object> get props => [credentials];
}
