import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:toptodo_data/toptodo_data.dart';

@immutable
class SettingsFormState extends Equatable {
  const SettingsFormState({
    this.tdBranch,
    this.tdCaller,
    this.tdCategories,
    this.tdCategory,
    this.tdDurations,
    this.tdDuration,
    this.tdOperators,
    this.tdOperator,
    this.tdSubcategories,
    this.tdSubcategory,
  });

  final TdBranch tdBranch;
  final TdCaller tdCaller;
  final Iterable<TdCategory> tdCategories;
  final TdCategory tdCategory;
  final Iterable<TdDuration> tdDurations;
  final TdDuration tdDuration;
  final Iterable<TdOperator> tdOperators;
  final TdOperator tdOperator;
  final Iterable<TdSubcategory> tdSubcategories;
  final TdSubcategory tdSubcategory;

  SettingsFormState update({
    TdBranch updatedTdBranch,
    TdCaller updatedTdCaller,
    Iterable<TdCategory> updatedTdCategories,
    TdCategory updatedTdCategory,
    Iterable<TdDuration> updatedTdDurations,
    TdDuration updatedTdDuration,
    Iterable<TdOperator> updatedTdOperators,
    TdOperator updatedTdOperator,
    Iterable<TdSubcategory> updatedTdSubcategories,
    TdSubcategory updatedTdSubcategory,
  }) =>
      SettingsFormState(
        tdBranch: updatedTdBranch ?? tdBranch,
        tdCategories: updatedTdCategories ?? tdCategories,
        tdCategory: updatedTdCategory ?? tdCategory,
        tdDurations: updatedTdDurations ?? tdDurations,
        tdDuration: updatedTdDuration ?? tdDuration,
        tdOperators: updatedTdOperators ?? tdOperators,
        tdOperator: updatedTdOperator ?? tdOperator,
        tdCaller: _updatedValue(
          value: updatedTdCaller,
          oldValue: tdCaller,
          linkedTo: updatedTdBranch,
          oldLinkedTo: tdBranch,
        ),
        tdSubcategories: _updatedValue(
          value: updatedTdSubcategories,
          oldValue: tdSubcategories,
          linkedTo: updatedTdCategory,
          oldLinkedTo: tdCategory,
        ),
        tdSubcategory: _updatedValue(
          value: updatedTdSubcategory,
          oldValue: tdSubcategory,
          linkedTo: updatedTdCategory,
          oldLinkedTo: tdCategory,
        ),
      );

  static dynamic _updatedValue({
    @required dynamic value,
    @required dynamic oldValue,
    @required dynamic linkedTo,
    @required dynamic oldLinkedTo,
  }) =>
      value ??
      ((linkedTo == null || linkedTo == oldLinkedTo) ? oldValue : null);

  Settings toSettings() => Settings(
        tdBranchId: tdBranch.id,
        tdCallerId: tdCaller.id,
        tdCategoryId: tdCategory.id,
        tdSubcategoryId: tdSubcategory.id,
        tdDurationId: tdDuration.id,
        tdOperatorId: tdOperator.id,
      );

  @override
  List<Object> get props => [
        tdBranch,
        tdCaller,
        tdCategories,
        tdCategory,
        tdDurations,
        tdDuration,
        tdOperators,
        tdOperator,
        tdSubcategories,
        tdSubcategory,
      ];

  @override
  String toString() => 'SettingsFormState {'
      'branch: $tdBranch, '
      'caller: $tdCaller, '
      'categories: $tdCategories, '
      'category: $tdCategory, '
      'subCategory: $tdSubcategory, '
      'subCategories: $tdSubcategories, '
      'durations: $tdDurations, '
      'duration: $tdDuration, '
      'operators: $tdOperators, '
      'operator: $tdOperator, '
      '}';
}
