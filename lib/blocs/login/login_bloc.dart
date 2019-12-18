import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
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
  bool remember;

  @override
  LoginState get initialState => const LoginWaitingForSavedData();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is AppStarted) {
      yield const LoginWaitingForSavedData();
      final Credentials credentials = await credentialsProvider.provide();

      yield RetrievedSavedData(credentials, true);
    } else if (event is RememberToggle) {
      yield RetrievedSavedData(event.credentials, event.remember);
    } else if (event is TryLogin) {
      yield const LoginSubmitting();
      await credentialsProvider.save(event.credentials);

      topdeskProvider.init(event.credentials);

      settingsProvider.init(event.credentials.url, event.credentials.loginName);
      final Settings settings = await settingsProvider.provide();
      // final bool settingsValid = _areSettingsValid(settings);

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

  // bool _areSettingsValid(Settings settings) {
  //   if (settings == null ||
  //       settings.branchId == null ||
  //       settings.callerId == null ||
  //       settings.categoryId == null ||
  //       settings.subcategoryId == null ||
  //       settings.incidentDurationId == null ||
  //       settings.incidentOperatorId == null) {
  //     return false;
  //   }
  // }
}
