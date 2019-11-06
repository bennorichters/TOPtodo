import 'package:equatable/equatable.dart';
import 'package:toptopdo/data/model/settings.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
}

class SettingsInit extends SettingsEvent {
  @override
  List<Object> get props => [];
}

class SettingsCategoryChosen extends SettingsEvent {
  final String categoryId;
  const SettingsCategoryChosen(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class SettingsSave extends SettingsEvent {
  final Settings settings;
  const SettingsSave(this.settings);

  @override
  List<Object> get props => [settings];
}
