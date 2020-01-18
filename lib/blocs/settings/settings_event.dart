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

class BranchSelected extends SettingsEvent {
  const BranchSelected(this.branch);
  final TdBranch branch;

  @override
  List<Object> get props => super.props..addAll([branch]);
}

class CategorySelected extends SettingsEvent {
  const CategorySelected(this.category);
  final TdCategory category;

  @override
  List<Object> get props => super.props..addAll([category]);
}

class DurationSelected extends SettingsEvent {
  const DurationSelected(this.duration);
  final TdDuration duration;

  @override
  List<Object> get props => super.props..addAll([duration]);
}

class OperatorSelected extends SettingsEvent {
  const OperatorSelected(this.tdOperator);
  final TdOperator tdOperator;

  @override
  List<Object> get props => super.props..addAll([tdOperator]);
}

class CallerSelected extends SettingsEvent {
  const CallerSelected(this.caller);
  final TdCaller caller;

  @override
  List<Object> get props => super.props..addAll([caller]);
}

class SubcategorySelected extends SettingsEvent {
  const SubcategorySelected(this.subcategory);
  final TdSubcategory subcategory;

  @override
  List<Object> get props => super.props..addAll([subcategory]);
}

class SettingsSave extends SettingsEvent {
  const SettingsSave();
}
