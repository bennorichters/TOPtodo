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

      try {
        final Settings settings =
            await settingsProvider.provide() ?? const Settings.empty();

        // throw const TdNotAuthorizedException('auth issue');

        if (_settingsComplete(settings)) {
          yield LoginSuccessValidSettings(
            topdeskProvider: topdeskProvider,
            settings: settings,
          );
        } else {
          yield LoginSuccessIncompleteSettings(
            topdeskProvider: topdeskProvider,
            settings: settings,
          );
        }
      } on TdNotAuthorizedException catch (e) {
        yield LoginFailed(
          savedData: event.credentials,
          remember: true,
          cause: e,
        );
      } on TdTimeOutException catch (e) {
        yield LoginFailed(
          savedData: event.credentials,
          remember: true,
          cause: e,
        );
      } on TdServerException catch (e) {
        yield LoginFailed(
          savedData: event.credentials,
          remember: true,
          cause: e,
        );
      }
    }
  }

  bool _settingsComplete(Settings settings) =>
      settings.branch != null &&
      settings.caller != null &&
      settings.category != null &&
      settings.subCategory != null &&
      settings.incidentDuration != null &&
      settings.incidentOperator != null;
}
