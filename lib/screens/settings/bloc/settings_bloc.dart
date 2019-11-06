import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:toptopdo/data/model/credentials.dart';
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

      _topdeskConnect(loginBloc.credentials);
    } else {}
  }

  void _topdeskConnect(Credentials credentials) async {
    final url = '${credentials.url}/tas/api/incidents/durations';

    // var res = await http.get(
    //   url,
    //   headers: _topdeskAuthHeaders(),
    // );

    // List<dynamic> elements = json.decode(res.body);

    // print(event);
  }
}
