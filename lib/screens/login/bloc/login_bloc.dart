import 'package:flutter/material.dart';

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:toptopdo/data/credentials_provider.dart';
import 'package:toptopdo/data/model/credentials.dart';
import 'package:toptopdo/data/settings_provider.dart';
import './bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final CredentialsProvider credentialsProvider;
  final SettingsProviderFactory settingsProviderFactory;
  LoginBloc({
    @required this.credentialsProvider,
    @required this.settingsProviderFactory,
  });

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
      await credentialsProvider.save(event.credentials);

      SettingsProvider settingsProvider = settingsProviderFactory(
        event.credentials.url,
        event.credentials.loginName,
      );
      final settings = await settingsProvider.provide();

      if (settings == null) {
        yield LoginSuccessNoSettings(credentials: event.credentials);
      } else {
        yield LoginSuccessWithSettings(
          credentials: event.credentials,
          settings: settings,
        );
      }
    }
  }

  Credentials get credentials {
    final currentState = state;
    if (currentState is LoginSuccessNoSettings) return currentState.credentials;
    if (currentState is LoginSuccessWithSettings)
      return currentState.credentials;

    throw Exception('No login success, state is: $currentState');
  }
}
