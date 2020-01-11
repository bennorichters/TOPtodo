import 'package:equatable/equatable.dart';
import 'package:toptodo_data/toptodo_data.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class SettingsInit extends SettingsEvent {
  const SettingsInit();
}

class SettingsBranchSelected extends SettingsEvent {
  const SettingsBranchSelected(this.branch);
  final TdBranch branch;

  @override
  List<Object> get props => super.props..addAll([branch]);
}

class SettingsCategorySelected extends SettingsEvent {
  const SettingsCategorySelected(this.category);
  final TdCategory category;

  @override
  List<Object> get props => super.props..addAll([category]);
}

class SettingsDurationSelected extends SettingsEvent {
  const SettingsDurationSelected(this.duration);
  final TdDuration duration;

  @override
  List<Object> get props => super.props..addAll([duration]);
}

class SettingsOperatorSelected extends SettingsEvent {
  const SettingsOperatorSelected(this.incidentOperator);
  final TdOperator incidentOperator;

  @override
  List<Object> get props => super.props..addAll([incidentOperator]);
}

class SettingsCallerSelected extends SettingsEvent {
  const SettingsCallerSelected(this.caller);
  final TdCaller caller;

  @override
  List<Object> get props => super.props..addAll([caller]);
}

class SettingsSubCategorySelected extends SettingsEvent {
  const SettingsSubCategorySelected(this.subCategory);
  final TdSubcategory subCategory;

  @override
  List<Object> get props => super.props..addAll([subCategory]);
}

class SettingsSave extends SettingsEvent {
  const SettingsSave();
}
