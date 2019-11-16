import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:toptodo_data/toptodo_data.dart';

import './bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this.topdeskProvider);

  final TopdeskProvider topdeskProvider;

  Branch _branch;
  Iterable<IncidentDuration> _durations;
  IncidentDuration _duration;
  Person _person;

  @override
  SettingsState get initialState => const SettingsTdData();

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is SettingsInit) {
      yield _updatedState();
      _durations = await topdeskProvider.fetchDurations();
      yield _updatedState();
    } else if (event is SettingsDurationSelected) {
      _duration = event.duration;
      yield _updatedState();
    } else if (event is SettingsBranchSelected) {
      _branch = event.branch;
      yield _updatedState();
    } else if (event is SettingsPersonSelected) {
      _person = event.person;
    } else {
      throw ArgumentError('unknown event $event');
    }
  }

  SettingsTdData _updatedState() => SettingsTdData(
        branch: _branch,
        durations: _durations,
        duration: _duration,
        person: _person,
      );
}
