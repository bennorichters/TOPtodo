import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:toptopdo/data/topdesk_api_provider.dart';
import './bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final TopdeskProvider topdeskProvider;
  SettingsBloc(this.topdeskProvider);

  @override
  SettingsState get initialState => SettingsNoSearchListData();

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is SettingsInit) {
      yield SettingsNoSearchListData();

      topdeskProvider.fetchDurations();
    } else {}
  }
}
