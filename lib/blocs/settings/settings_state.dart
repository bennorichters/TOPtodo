import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:toptodo/blocs/settings/settings_form_state.dart';
import 'package:toptodo_data/toptodo_data.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class InitialSettingsState extends SettingsState {
  const InitialSettingsState();
}

class SettingsWithOperator extends SettingsState {
  const SettingsWithOperator({@required this.currentOperator});
  final IncidentOperator currentOperator;

  @override
  List<Object> get props => super.props..addAll([currentOperator]);
}

class SettingsLoading extends SettingsWithOperator {
  const SettingsLoading({@required IncidentOperator currentOperator})
      : super(currentOperator: currentOperator);
}

abstract class SettingsWithFormState extends SettingsWithOperator {
  const SettingsWithFormState({
    @required IncidentOperator currentOperator,
    @required this.formState,
  }) : super(currentOperator: currentOperator);
  final SettingsFormState formState;

  @override
  List<Object> get props => super.props..addAll([formState]);

  @override
  String toString() => '${runtimeType} - $formState';
}

class SettingsTdData extends SettingsWithFormState {
  const SettingsTdData({
    @required IncidentOperator currentOperator,
    @required SettingsFormState formState,
  }) : super(
          currentOperator: currentOperator,
          formState: formState,
        );
}

class SettingsSaved extends SettingsWithFormState {
  const SettingsSaved({
    @required IncidentOperator currentOperator,
    @required SettingsFormState formState,
  }) : super(
          currentOperator: currentOperator,
          formState: formState,
        );
}
