import 'package:equatable/equatable.dart';
import 'package:toptodo_data/toptodo_data.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class SettingsInit extends SettingsEvent {
  const SettingsInit();
}

class ValueSelected extends SettingsEvent {
  const ValueSelected({
    this.tdBranch,
    this.tdCaller,
    this.tdCategory,
    this.tdSubcategory,
    this.tdDuration,
    this.tdOperator,
  });

  final TdBranch tdBranch;
  final TdCaller tdCaller;
  final TdCategory tdCategory;
  final TdSubcategory tdSubcategory;
  final TdDuration tdDuration;
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

class SettingsSave extends SettingsEvent {
  const SettingsSave();
}
