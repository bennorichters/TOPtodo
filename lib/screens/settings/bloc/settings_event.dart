import 'package:equatable/equatable.dart';
import 'package:toptopdo/data/model/settings.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
}

class SettingsInit extends SettingsEvent {
  @override
  List<Object> get props => [];
}

class SettingsDurationSelected extends SettingsEvent {
  final String durationId;
  const SettingsDurationSelected(this.durationId);

  @override
  List<Object> get props => [durationId];
}

class SettingsCategorySelected extends SettingsEvent {
  final String categoryId;
  const SettingsCategorySelected(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class SettingsSave extends SettingsEvent {
  final Settings settings;
  const SettingsSave(this.settings);

  @override
  List<Object> get props => [settings];
}
