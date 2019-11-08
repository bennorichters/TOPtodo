import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:toptopdo/screens/login/bloc/bloc.dart';
import './bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final LoginBloc loginBloc;
  SettingsBloc(this.loginBloc);

  @override
  SettingsState get initialState => SettingsNoSearchListData();

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is SettingsInit) {
      yield SettingsNoSearchListData();

      print('here ${(loginBloc.state as LoginSuccessNoSettings).topdeskProvider}');

      // _topdeskConnect(loginBloc.credentials);
    } else {}
  }
}
