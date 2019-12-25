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

  final Branch branch;
  final Caller caller;
  final Iterable<Category> categories;
  final Category category;
  final Iterable<IncidentDuration> incidentDurations;
  final IncidentDuration incidentDuration;
  final Iterable<IncidentOperator> incidentOperators;
  final IncidentOperator incidentOperator;
  final Iterable<SubCategory> subCategories;
  final SubCategory subCategory;

  SettingsFormState update({
    Branch updatedBranch,
    Caller updatedCaller,
    Iterable<Category> updatedCategories,
    Category updatedCategory,
    Iterable<IncidentDuration> updatedDurations,
    IncidentDuration updatedDuration,
    Iterable<IncidentOperator> updatedIncidentOperators,
    IncidentOperator updatedIncidentOperator,
    Iterable<SubCategory> updatedSubCategories,
    SubCategory updatedSubCategory,
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
          linkedTo: updatedCaller,
          oldLinkedTo: branch,
        ) as Caller,
        subCategories: _updatedValue(
          value: updatedSubCategories,
          oldValue: subCategories,
          linkedTo: updatedCategory,
          oldLinkedTo: category,
        ) as Iterable<SubCategory>,
        subCategory: _updatedValue(
          value: updatedSubCategory,
          oldValue: subCategory,
          linkedTo: updatedCategory,
          oldLinkedTo: category,
        ) as SubCategory,
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
        branchId: branch.id,
        callerId: caller.id,
        categoryId: category.id,
        subCategoryId: subCategory.id,
        incidentDurationId: incidentDuration.id,
        incidentOperatorId: incidentOperator.id,
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
  String toString() => 'SettingsState {'
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
