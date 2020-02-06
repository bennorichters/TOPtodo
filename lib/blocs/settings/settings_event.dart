import 'package:equatable/equatable.dart';
import 'package:toptodo_data/toptodo_data.dart';

/// Base class for all events related to settings
abstract class SettingsEvent extends Equatable {
  /// Creates a [SettingsEvent]
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

/// Event that triggers the bloc to load all settings data
class SettingsInit extends SettingsEvent {
  /// Creates a [SettingsInit]
  const SettingsInit();
}

/// Event to update the bloc when the user chose a value.
///
/// Only one of the fields should hold an actual value, the rest of the fields
/// should be `null`. That non-null value is processed by the bloc. If more than
/// one field hold a value, only one (unspecified which) will be processed.
class ValueSelected extends SettingsEvent {
  /// Creates an instance of [ValueSelected]. 
  /// 
  /// One of the fields should hold a value, the others should be `null`.
  const ValueSelected({
    this.tdBranch,
    this.tdCaller,
    this.tdCategory,
    this.tdSubcategory,
    this.tdDuration,
    this.tdOperator,
  });

  /// the branch
  final TdBranch tdBranch;

  /// the caller
  final TdCaller tdCaller;

  /// the cateory
  final TdCategory tdCategory;

  /// the subcategory
  final TdSubcategory tdSubcategory;

  /// the duration
  final TdDuration tdDuration;

  /// the operator
  final TdOperator tdOperator;

  @override
  List<Object> get props => super.props
    ..addAll([
      tdBranch,
      tdCaller,
      tdCategory,
      tdSubcategory,
      tdDuration,
      tdOperator,
    ]);
}

/// Events that triggers the bloc to save the chosen data
class SettingsSave extends SettingsEvent {
  /// Creates a [SettingsSave]
  const SettingsSave();
}
