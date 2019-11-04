import 'package:flutter/material.dart';

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:toptopdo/data/credentials_provider.dart';
import 'package:toptopdo/data/model/credentials.dart';
import './bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final CredentialsProvider credentialsProvider;
  LoginBloc({@required this.credentialsProvider});

  @override
  LoginState get initialState => LoginWaitingForSavedData();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is AppStarted) {
      yield LoginWaitingForSavedData();
      Credentials credentials = await credentialsProvider.provide();
      yield RetrievedSavedData(credentials);
    } else if (event is TryLogin) {
      yield LoginSubmitting();
      credentialsProvider.save(event.credentials);
      yield LoginSuccess(event.credentials.url);
    }
  }
}
