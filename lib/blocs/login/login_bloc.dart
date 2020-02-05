import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:toptodo/blocs/login/bloc.dart';
import 'package:toptodo_data/toptodo_data.dart';

/// Business logic component related to login
///
/// This component can retrieve, save and delete [Credentials] information from
/// a [CredentialsProvider]. It can retrieve [Settings] from a
/// [SettingsProvider] and can retrieve the current operator from an
/// [TopdeskProvider].
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  /// Creates an instance of a [LoginBloc]
  LoginBloc({
    @required this.credentialsProvider,
    @required this.settingsProvider,
    @required this.topdeskProvider,
  });

  /// the credentials provider
  final CredentialsProvider credentialsProvider;

  /// the settings provider
  final SettingsProvider settingsProvider;

  /// the topdesk provider
  final TopdeskProvider topdeskProvider;

  Credentials _credentials;
  bool _remember = false;

  @override
  LoginState get initialState => const AwaitingCredentials();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is CredentialsInit) {
      yield const AwaitingCredentials();
      _credentials = await credentialsProvider.provide();
      _remember = _credentials.isComplete();
      yield RetrievedCredentials(_credentials, _remember);
    } else if (event is LogOut) {
      yield const AwaitingCredentials();
      await credentialsProvider.delete();
      _credentials = Credentials();
      _remember = false;
      yield RetrievedCredentials(_credentials, _remember);
    } else if (event is RememberToggle) {
      _credentials = event.credentials;
      _remember = !_remember;

      if (!_remember) {
        await credentialsProvider.delete();
      }

      yield RetrievedCredentials(_credentials, _remember);
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

        yield LoginSuccess(
          topdeskProvider: topdeskProvider,
          settings: settings,
        );
      } catch (error, stackTrace) {
        yield LoginFailed(
          savedData: _credentials,
          remember: _remember,
          cause: error,
          stackTrace: stackTrace,
        );
      }
    }
  }
}

Credentials _fixCredentials(Credentials credentials) {
  var url = credentials.url.trim();
  if (!(url.toLowerCase().startsWith('http://') ||
      url.toLowerCase().startsWith('https://'))) {
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
