import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:toptopdo/data/model/topdesk_elements.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
}

class SettingsNoSearchListData extends SettingsState {
  @override
  List<Object> get props => <Object> [];
}

class SettingsRetrievedDurations extends SettingsState {
  const SettingsRetrievedDurations({
    @required this.durations,
    @required this.selectedDurationId,
  });

  final List<IncidentDuration> durations;
  final String selectedDurationId;

  @override
  List<Object> get props => <Object> [durations, selectedDurationId];
}
