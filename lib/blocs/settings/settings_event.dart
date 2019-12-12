import 'package:equatable/equatable.dart';
import 'package:toptodo_data/toptodo_data.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
}

class SettingsInit extends SettingsEvent {
  @override
  List<Object> get props => <Object>[];
}

class SettingsBranchSelected extends SettingsEvent {
  const SettingsBranchSelected(this.branch);
  final Branch branch;

  @override
  List<Object> get props => <Object>[branch];
}

class SettingsCategorySelected extends SettingsEvent {
  const SettingsCategorySelected(this.category);
  final Category category;

  @override
  List<Object> get props => <Object>[category];
}

class SettingsDurationSelected extends SettingsEvent {
  const SettingsDurationSelected(this.duration);
  final IncidentDuration duration;

  @override
  List<Object> get props => <Object>[duration];
}

class SettingsOperatorSelected extends SettingsEvent {
  const SettingsOperatorSelected(this.incidentOperator);
  final IncidentOperator incidentOperator;

  @override
  List<Object> get props => <Object>[incidentOperator];
}

class SettingsCallerSelected extends SettingsEvent {
  const SettingsCallerSelected(this.caller);
  final Caller caller;

  @override
  List<Object> get props => <Object>[caller];
}

class SettingsSubCategorySelected extends SettingsEvent {
  const SettingsSubCategorySelected(this.subCategory);
  final SubCategory subCategory;

  @override
  List<Object> get props => <Object>[subCategory];
}

class SettingsSave extends SettingsEvent {
  @override
  List<Object> get props => <Object>[];
}

class SettingsUserLoggedOut extends SettingsEvent {
  @override
  List<Object> get props => <Object>[];
}
