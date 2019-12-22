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

class SettingsWithFormState extends SettingsState {
  const SettingsWithFormState({@required this.formState});
  final SettingsFormState formState;

  @override
  List<Object> get props => <Object>[formState];
}

class SettingsTdData extends SettingsWithFormState {
  const SettingsTdData({@required SettingsFormState formState})
      : super(formState: formState);
}

class SettingsLogout extends SettingsWithFormState {
  const SettingsLogout({@required SettingsFormState formState})
      : super(formState: formState);
}
