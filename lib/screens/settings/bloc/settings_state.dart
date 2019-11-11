import 'package:equatable/equatable.dart';
import 'package:toptopdo/data/model/topdesk_elements.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
}

class SettingsTdData extends SettingsState {
  const SettingsTdData({
    this.branchId,
    this.branchName,
    this.durations,
    this.selectedDurationId,
  });

  final String branchId;
  final String branchName;
  final List<IncidentDuration> durations;
  final String selectedDurationId;

  @override
  List<Object> get props => <Object>[
        branchId,
        branchName,
        durations,
        selectedDurationId,
      ];
}
