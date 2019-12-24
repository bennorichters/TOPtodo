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

  Credentials _credentials;
  bool _remember = false;

  @override
  LoginState get initialState => const LoginWaitingForSavedData();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is AppStarted) {
      yield const LoginWaitingForSavedData();
      _credentials = await credentialsProvider.provide();

      yield RetrievedSavedData(_credentials, _remember);
    } else if (event is LogOut) {
      yield const LoginWaitingForSavedData();
      await credentialsProvider.delete();
      _credentials = Credentials.empty();
      _remember = false;
      yield RetrievedSavedData(_credentials, _remember);
    } else if (event is RememberToggle) {
      _credentials = event.credentials;
      _remember = !_remember;

      if (!_remember) {
        await credentialsProvider.delete();
      }

      yield RetrievedSavedData(_credentials, _remember);
    } else if (event is TryLogin) {
      _credentials = event.credentials;

      yield const LoginSubmitting();

      if (_remember) {
        await credentialsProvider.save(_credentials);
      }

      topdeskProvider.dispose();
      topdeskProvider.init(_credentials);

      settingsProvider.dispose();
      settingsProvider.init(_credentials.url, _credentials.loginName);

      try {
        final settings =
            await settingsProvider.provide() ?? const Settings.empty();

        if (settings.isComplete()) {
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
          savedData: _credentials,
          remember: _remember,
          message: 'You do not have sufficient authorization.\n'
              '\n'
              'Contact your TOPdesk application manager.',
          cause: e,
        );
      } on TdTimeOutException catch (e) {
        yield LoginFailed(
          savedData: _credentials,
          remember: _remember,
          message: 'It took the TOPdesk server too long to respond.\n'
              '\n'
              'Please try again later.',
          cause: e,
        );
      } on TdServerException catch (e) {
        yield LoginFailed(
          savedData: _credentials,
          remember: _remember,
          message: 'There was a problem with the TOPdesk server.'
              '\n'
              'Contact your TOPdesk application manager.',
          cause: e,
        );
      }
    }
  }
}
