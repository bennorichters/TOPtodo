import 'package:equatable/equatable.dart';
import 'package:toptopdo/data/model/settings.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
}

class SettingsInit extends SettingsEvent {
  @override
  List<Object> get props => <Object> [];
}

class SettingsDurationSelected extends SettingsEvent {
  const SettingsDurationSelected(this.durationId);
  final String durationId;

  @override
  List<Object> get props => <Object> [durationId];
}

class SettingsCategorySelected extends SettingsEvent {
  const SettingsCategorySelected(this.categoryId);
  final String categoryId;

  @override
  List<Object> get props => <Object> [categoryId];
}

class SettingsSave extends SettingsEvent {
  const SettingsSave(this.settings);
  final Settings settings;

  @override
  List<Object> get props => <Object> [settings];
}
