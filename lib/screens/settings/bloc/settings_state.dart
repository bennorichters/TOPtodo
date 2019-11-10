import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:toptopdo/data/model/topdesk_elements.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
}

class SettingsNoSearchListData extends SettingsState {
  @override
  List<Object> get props => [];
}

class SettingsRetrievedDurations extends SettingsState {
  final List<IncidentDuration> durations;
  final String selectedDurationId;
  SettingsRetrievedDurations({
    @required this.durations,
    @required this.selectedDurationId,
  });

  @override
  List<Object> get props => [durations, selectedDurationId];
}
