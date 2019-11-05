import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:toptopdo/data/model/credentials.dart';
import 'package:toptopdo/data/model/settings.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginWaitingForSavedData extends LoginState {
  const LoginWaitingForSavedData();

  @override
  List<Object> get props => [];
}

class RetrievedSavedData extends LoginState {
  final Credentials savedData;
  const RetrievedSavedData(this.savedData);

  @override
  List<Object> get props => [savedData];
}

class LoginSubmitting extends LoginState {
  const LoginSubmitting();

  @override
  List<Object> get props => [];
}

class LoginSuccess extends LoginState {
  final Credentials credentials;
  final Settings settings;
  const LoginSuccess({
    @required this.credentials,
    @required this.settings,
  });

  @override
  List<Object> get props => [credentials];
}

// class LoginFailed extends LoginState {
//   final String message;
//   const LoginFailed(this.message);

//   @override
//   List<Object> get props => [message];
// }
