import 'package:flutter/material.dart';

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:toptopdo/data/credentials_provider.dart';
import 'package:toptopdo/data/model/credentials.dart';
import 'package:toptopdo/data/settings_provider.dart';
import 'package:toptopdo/data/topdesk_api_provider.dart';
import './bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final CredentialsProvider credentialsProvider;
  final SettingsProviderFactory settingsProviderFactory;
  final TopdeskProviderFactory topdeskProviderFactory;
  LoginBloc({
    @required this.credentialsProvider,
    @required this.settingsProviderFactory,
    @required this.topdeskProviderFactory,
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

      final tdProvider = topdeskProviderFactory(event.credentials);

      SettingsProvider settingsProvider = settingsProviderFactory(
        event.credentials.url,
        event.credentials.loginName,
      );
      final settings = await settingsProvider.provide();

      if (settings == null) {
        yield LoginSuccessNoSettings(
          topdeskProvider: tdProvider,
        );
      } else {
        yield LoginSuccessWithSettings(
          topdeskProvider: tdProvider,
          settings: settings,
        );
      }
    }
  }

  TopdeskProvider get topdeskProvider {
    final currentState = state;
    if (currentState is LoginSuccessNoSettings)
      return currentState.topdeskProvider;
    if (currentState is LoginSuccessWithSettings)
      return currentState.topdeskProvider;

    throw Exception('No login success, state is: $currentState');
  }
}
