import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:toptodo_data/toptodo_data.dart';

@immutable
class SettingsFormState extends Equatable {
  const SettingsFormState({
    this.branch,
    this.caller,
    this.categories,
    this.category,
    this.incidentDurations,
    this.incidentDuration,
    this.incidentOperators,
    this.incidentOperator,
    this.subCategories,
    this.subCategory,
  });

  final TdBranch branch;
  final TdCaller caller;
  final Iterable<TdCategory> categories;
  final TdCategory category;
  final Iterable<TdDuration> incidentDurations;
  final TdDuration incidentDuration;
  final Iterable<TdOperator> incidentOperators;
  final TdOperator incidentOperator;
  final Iterable<TdSubcategory> subCategories;
  final TdSubcategory subCategory;

  SettingsFormState update({
    TdBranch updatedBranch,
    TdCaller updatedCaller,
    Iterable<TdCategory> updatedCategories,
    TdCategory updatedCategory,
    Iterable<TdDuration> updatedDurations,
    TdDuration updatedDuration,
    Iterable<TdOperator> updatedIncidentOperators,
    TdOperator updatedIncidentOperator,
    Iterable<TdSubcategory> updatedSubCategories,
    TdSubcategory updatedSubCategory,
  }) =>
      SettingsFormState(
        branch: updatedBranch ?? branch,
        categories: updatedCategories ?? categories,
        category: updatedCategory ?? category,
        incidentDurations: updatedDurations ?? incidentDurations,
        incidentDuration: updatedDuration ?? incidentDuration,
        incidentOperators: updatedIncidentOperators ?? incidentOperators,
        incidentOperator: updatedIncidentOperator ?? incidentOperator,
        caller: _updatedValue(
          value: updatedCaller,
          oldValue: caller,
          linkedTo: updatedBranch,
          oldLinkedTo: branch,
        ),
        subCategories: _updatedValue(
          value: updatedSubCategories,
          oldValue: subCategories,
          linkedTo: updatedCategory,
          oldLinkedTo: category,
        ),
        subCategory: _updatedValue(
          value: updatedSubCategory,
          oldValue: subCategory,
          linkedTo: updatedCategory,
          oldLinkedTo: category,
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
        tdBranchId: branch.id,
        tdCallerId: caller.id,
        tdCategoryId: category.id,
        tdSubcategoryId: subCategory.id,
        tdDurationId: incidentDuration.id,
        tdOperatorId: incidentOperator.id,
      );

  @override
  List<Object> get props => [
        branch,
        caller,
        categories,
        category,
        incidentDurations,
        incidentDuration,
        incidentOperators,
        incidentOperator,
        subCategories,
        subCategory,
      ];

  @override
  String toString() => 'SettingsFormState {'
      'branch: $branch, '
      'caller: $caller, '
      'categories: $categories, '
      'category: $category, '
      'subCategory: $subCategory, '
      'subCategories: $subCategories, '
      'durations: $incidentDurations, '
      'duration: $incidentDuration, '
      'operators: $incidentOperators, '
      'operator: $incidentOperator, '
      '}';
}
