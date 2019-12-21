import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:toptodo/blocs/settings/settings_form_state.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
}

class SettingsLoading extends SettingsState {
  @override
  List<Object> get props => <Object>[];
}

class SettingsTdData extends SettingsState {
  const SettingsTdData({@required this.formState});
  final SettingsFormState formState;

  @override
  List<Object> get props => <Object>[formState];
}

class SettingsLogout extends SettingsState {
  const SettingsLogout({@required this.formState});
  final SettingsFormState formState;

  @override
  List<Object> get props => <Object>[formState];
}
