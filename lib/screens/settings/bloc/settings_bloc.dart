import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:toptopdo/screens/login/bloc/login_bloc.dart';
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
    } else  {
      print(event);
    }
  }
}
