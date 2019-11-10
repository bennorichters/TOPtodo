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
  SettingsState get initialState => const SettingsTdData();

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is SettingsInit) {
      yield const SettingsTdData();

      durations = await topdeskProvider.fetchDurations();
      yield SettingsTdData(
        durations: durations,
        selectedDurationId: null,
      );
    } else if (event is SettingsDurationSelected) {
      yield SettingsTdData(
        durations: durations,
        selectedDurationId: event.durationId,
      );
    } else {}
  }
}
