import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:toptopdo/data/model/topdesk_elements.dart';
import 'package:toptopdo/data/topdesk_api_provider.dart';
import './bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this.topdeskProvider);

  final TopdeskProvider topdeskProvider;
  List<IncidentDuration> durations;

  @override
  SettingsState get initialState => SettingsInitial();

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is SettingsInit) {
      yield SettingsInitial();

      durations = await topdeskProvider.fetchDurations();
      print(durations);

      yield SettingsNewTdData(
        durations: durations,
        selectedDurationId: null,
      );
    } else if (event is SettingsDurationSelected) {
      yield SettingsNewTdData(
        durations: durations,
        selectedDurationId: event.durationId,
      );
    } else {}
  }
}
