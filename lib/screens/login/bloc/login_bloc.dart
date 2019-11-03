import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:toptopdo/data/model/credentials.dart';
import './bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  @override
  LoginState get initialState => LoginWaitingForSavedData();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is AppStarted) {
      yield LoginWaitingForSavedData();

      final storage = FlutterSecureStorage();
      final url = await storage.read(key: 'url');
      final loginName = await storage.read(key: 'loginName');
      final password = await storage.read(key: 'password');

      final credentials = Credentials(
        url: url,
        loginName: loginName,
        password: password,
      );

      yield RetrievedSavedData(credentials);
    } else if (event is TryLogin) {
      yield LoginSubmitting();

      final storage = FlutterSecureStorage();
      storage.write(
        key: 'url',
        value: event.credentials.url,
      );
      storage.write(
        key: 'loginName',
        value: event.credentials.loginName,
      );
      storage.write(
        key: 'password',
        value: event.credentials.password,
      );
    }
  }
}
