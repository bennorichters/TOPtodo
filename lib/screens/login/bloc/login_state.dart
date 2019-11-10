import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:toptopdo/data/model/credentials.dart';
import 'package:toptopdo/data/model/settings.dart';
import 'package:toptopdo/data/topdesk_api_provider.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginWaitingForSavedData extends LoginState {
  const LoginWaitingForSavedData();

  @override
  List<Object> get props => <Object>[];
}

class RetrievedSavedData extends LoginState {
  const RetrievedSavedData(this.savedData);
  final Credentials savedData;

  @override
  List<Object> get props => <Object>[savedData];
}

class LoginSubmitting extends LoginState {
  const LoginSubmitting();

  @override
  List<Object> get props => <Object>[];
}

class LoginSuccessNoSettings extends LoginState {
  const LoginSuccessNoSettings({@required this.topdeskProvider});
  final TopdeskProvider topdeskProvider;

  @override
  List<Object> get props => <Object>[topdeskProvider];
}

class LoginSuccessWithSettings extends LoginState {
  const LoginSuccessWithSettings({
    @required this.topdeskProvider,
    @required this.settings,
  });

  final TopdeskProvider topdeskProvider;
  final Settings settings;

  @override
  List<Object> get props => <Object> [topdeskProvider, settings];
}

// class LoginFailed extends LoginState {
//   final String message;
//   const LoginFailed(this.message);

//   @override
//   List<Object> get props => [message];
// }
