import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:toptodo/blocs/settings/settings_form_state.dart';
import 'package:toptodo_data/toptodo_data.dart';

/// Base class for all state objects related to settings
abstract class SettingsState extends Equatable {
  /// Creates a [SettingsSate]
  const SettingsState();

  @override
  List<Object> get props => [];
}

/// State emitted when the bloc is initialized
class InitialSettingsState extends SettingsState {
  /// Creates a [InitialSettingsState]
  const InitialSettingsState();
}

/// Base class for state objects that hold the current operator
abstract class SettingsWithOperator extends SettingsState {
  const SettingsWithOperator({@required this.currentOperator});
  final TdOperator currentOperator;

  @override
  List<Object> get props => super.props..addAll([currentOperator]);

  @override
  String toString() => '$runtimeType: '
      'currentOperator: $currentOperator';
}

class SettingsLoading extends SettingsWithOperator {
  const SettingsLoading({@required TdOperator currentOperator})
      : super(currentOperator: currentOperator);
}

abstract class SettingsWithForm extends SettingsWithOperator {
  const SettingsWithForm({
    @required TdOperator currentOperator,
    @required this.formState,
  }) : super(currentOperator: currentOperator);
  final SettingsFormState formState;

  @override
  List<Object> get props => super.props..addAll([formState]);

  @override
  String toString() => super.toString() + ', formState: $formState';
}

class UpdatedSettingsForm extends SettingsWithForm {
  const UpdatedSettingsForm({
    @required TdOperator currentOperator,
    @required SettingsFormState formState,
  }) : super(
          currentOperator: currentOperator,
          formState: formState,
        );
}

class SettingsSaved extends SettingsWithForm {
  const SettingsSaved({
    @required TdOperator currentOperator,
    @required SettingsFormState formState,
  }) : super(
          currentOperator: currentOperator,
          formState: formState,
        );
}

class SettingsError extends SettingsState {
  const SettingsError(this.cause, this.stackTrace);
  final Object cause;
  final StackTrace stackTrace;

  @override
  List<Object> get props => super.props..addAll([cause]);

  @override
  String toString() => 'SettingsError error: $cause';
}
