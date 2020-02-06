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

/// Base class for setting state objects that hold the current operator
abstract class SettingsWithOperator extends SettingsState {
  /// Creates an instance of [SettingsWithOperator]
  const SettingsWithOperator({@required this.currentOperator});

  /// the current operator
  final TdOperator currentOperator;

  @override
  List<Object> get props => super.props..addAll([currentOperator]);

  @override
  String toString() => '$runtimeType: '
      'currentOperator: $currentOperator';
}

/// State emitted when the bloc started to load saved settings and is waiting
/// for the results.
class SettingsLoading extends SettingsWithOperator {
  /// Creates an instance of [SettingsLoading]
  const SettingsLoading({@required TdOperator currentOperator})
      : super(currentOperator: currentOperator);
}

/// Base class for all setting state objects that hold a [SettingFormState]
abstract class SettingsWithForm extends SettingsWithOperator {
  /// Creates an instance of [SettingsWithForm]
  const SettingsWithForm({
    @required TdOperator currentOperator,
    @required this.formState,
  }) : super(currentOperator: currentOperator);

  /// The form state
  final SettingsFormState formState;

  @override
  List<Object> get props => super.props..addAll([formState]);

  @override
  String toString() => super.toString() + ', formState: $formState';
}

/// State emitted when the bloc has updated form state
class UpdatedSettingsForm extends SettingsWithForm {
  /// Creates an instance of [UpdatedSettingsForm]
  const UpdatedSettingsForm({
    @required TdOperator currentOperator,
    @required SettingsFormState formState,
  }) : super(
          currentOperator: currentOperator,
          formState: formState,
        );
}

/// State emitted when the settings have been saved by the bloc
class SettingsSaved extends SettingsWithForm {
  /// Creates a new instance of [SettingsSaved]
  const SettingsSaved({
    @required TdOperator currentOperator,
    @required SettingsFormState formState,
  }) : super(
          currentOperator: currentOperator,
          formState: formState,
        );
}

/// State emitted when the bloc encountered an error
class SettingsError extends SettingsState {
  /// Creates a new instance of [SettingsError]
  const SettingsError(this.cause, this.stackTrace);
  final Object cause;
  final StackTrace stackTrace;

  @override
  List<Object> get props => super.props..addAll([cause]);

  @override
  String toString() => 'SettingsError error: $cause';
}
