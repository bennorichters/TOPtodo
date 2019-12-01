import 'package:equatable/equatable.dart';
import 'package:toptodo/blocs/settings/settings_form_state.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
}

class SettingsTdData extends SettingsState {
  const SettingsTdData({this.formState});
  final SettingsFormState formState;

  @override
  List<Object> get props => <Object>[formState];
}

class SettingsLogout extends SettingsState {
  @override
  List<Object> get props => <Object>[];
}
