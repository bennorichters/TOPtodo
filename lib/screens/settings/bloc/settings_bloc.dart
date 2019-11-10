import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:toptopdo/data/model/topdesk_elements.dart';
import 'package:toptopdo/data/topdesk_api_provider.dart';
import './bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final TopdeskProvider topdeskProvider;
  List<IncidentDuration> durations;

  SettingsBloc(this.topdeskProvider);

  @override
  SettingsState get initialState => SettingsNoSearchListData();

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is SettingsInit) {
      yield SettingsNoSearchListData();

      durations = await topdeskProvider.fetchDurations();
      print(durations);

      yield SettingsRetrievedDurations(
        durations: durations,
        selectedDurationId: null,
      );
    } else if (event is SettingsDurationSelected) {
      yield SettingsRetrievedDurations(
        durations: durations,
        selectedDurationId: event.durationId,
      );
    } else {}
  }
}
