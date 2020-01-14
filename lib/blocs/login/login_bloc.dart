import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:toptodo/blocs/login/bloc.dart';
import 'package:toptodo_data/toptodo_data.dart';

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
    if (event is CredentialsInit) {
      yield const LoginWaitingForSavedData();
      _credentials = await credentialsProvider.provide();
      _remember = _credentials.isComplete();
      yield RetrievedSavedData(_credentials, _remember);
    } else if (event is LogOut) {
      yield const LoginWaitingForSavedData();
      await credentialsProvider.delete();
      _credentials = Credentials();
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
      yield const LoginSubmitting();

      _credentials = _fixCredentials(event.credentials);
      if (_remember) {
        await credentialsProvider.save(_credentials);
      }

      settingsProvider.dispose();
      settingsProvider.init(_credentials.url, _credentials.loginName);

      try {
        topdeskProvider.dispose();
        await topdeskProvider.init(_credentials);
        await topdeskProvider.currentTdOperator();

        final settings = await settingsProvider.provide() ?? const Settings();

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
      } catch (e) {
        yield LoginFailed(
          savedData: _credentials,
          remember: _remember,
          cause: e,
        );
      }
    }
  }
}

Credentials _fixCredentials(Credentials credentials) {
  var url = credentials.url.trim();
  if (!(url.toLowerCase().startsWith('http://') ||
      url.toLowerCase().startsWith('http://'))) {
    url = 'https://' + url;
  }

  while (url.endsWith('/')) {
    url = url.substring(0, url.length - 1);
  }

  return Credentials(
    url: url,
    loginName: credentials.loginName.trim().toLowerCase(),
    password: credentials.password,
  );
}
