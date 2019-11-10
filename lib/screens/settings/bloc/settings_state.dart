import 'package:equatable/equatable.dart';
import 'package:toptopdo/data/model/topdesk_elements.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
}

class SettingsTdData extends SettingsState {
  const SettingsTdData({
    this.durations,
    this.selectedDurationId,
  });

  final List<IncidentDuration> durations;
  final String selectedDurationId;

  @override
  List<Object> get props => <Object> [durations, selectedDurationId];
}
