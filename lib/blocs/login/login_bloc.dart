import 'dart:async';
import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:toptodo_data/toptodo_data.dart';

import './bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    @required this.credentialsProvider,
    @required this.topdeskProvider,
    @required this.settingsProvider,
  });

  final CredentialsProvider credentialsProvider;
  final TopdeskProvider topdeskProvider;
  final SettingsProvider settingsProvider;

  @override
  LoginState get initialState => const LoginWaitingForSavedData();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is AppStarted) {
      yield const LoginWaitingForSavedData();
      final Credentials credentials = await credentialsProvider.provide();
      yield RetrievedSavedData(credentials);
    } else if (event is TryLogin) {
      yield const LoginSubmitting();
      await credentialsProvider.save(event.credentials);

      topdeskProvider.init(event.credentials);

      settingsProvider.init(event.credentials.url, event.credentials.loginName);
      final Settings settings = await settingsProvider.provide();

      if (settings == null) {
        yield LoginSuccessNoSettings(
          topdeskProvider: topdeskProvider,
        );
      } else {
        yield LoginSuccessWithSettings(
          topdeskProvider: topdeskProvider,
          settings: settings,
        );
      }
    }
  }
}
