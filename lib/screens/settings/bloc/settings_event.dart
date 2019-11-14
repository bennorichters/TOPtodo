import 'package:equatable/equatable.dart';
import 'package:toptopdo/models/topdesk_elements.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
}

class SettingsInit extends SettingsEvent {
  @override
  List<Object> get props => <Object> [];
}

class SettingsBranchSelected extends SettingsEvent {
  const SettingsBranchSelected(this.branch);
  final Branch branch;

  @override
  List<Object> get props => <Object> [branch];
}

class SettingsDurationSelected extends SettingsEvent {
  const SettingsDurationSelected(this.duration);
  final IncidentDuration duration;

  @override
  List<Object> get props => <Object> [duration];
}
