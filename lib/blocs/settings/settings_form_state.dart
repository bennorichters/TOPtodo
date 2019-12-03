import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:toptodo_data/toptodo_data.dart';

class SettingsFormState extends Equatable {
  const SettingsFormState({
    this.categories,
    this.category,
    this.branch,
    this.durations,
    this.duration,
    this.incidentOperators,
    this.incidentOperator,
    this.person,
    this.subCategories,
    this.subCategory,
  });

  final Iterable<Category> categories;
  final Category category;
  final Branch branch;
  final Iterable<IncidentDuration> durations;
  final IncidentDuration duration;
  final Iterable<Operator> incidentOperators;
  final Operator incidentOperator;
  final Person person;
  final Iterable<SubCategory> subCategories;
  final SubCategory subCategory;

  SettingsFormState update({
    Branch updatedBranch,
    Iterable<Category> updatedCategories,
    Category updatedCategory,
    Iterable<IncidentDuration> updatedDurations,
    IncidentDuration updatedDuration,
    Iterable<Operator> updatedIncidentOperators,
    Operator updatedIncidentOperator,
    Person updatedPerson,
    Iterable<SubCategory> updatedSubCategories,
    SubCategory updatedSubCategory,
  }) =>
      SettingsFormState(
        branch: updatedBranch ?? branch,
        categories: updatedCategories ?? categories,
        category: updatedCategory ?? category,
        durations: updatedDurations ?? durations,
        duration: updatedDuration ?? duration,
        incidentOperators: updatedIncidentOperators ?? incidentOperators,
        incidentOperator: updatedIncidentOperator ?? incidentOperator,
        person: _updatedValue(
          value: updatedPerson,
          oldValue: person,
          linkedTo: updatedPerson,
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
          linkedTo: updatedSubCategory,
          oldLinkedTo: category,
        ),
      );

  dynamic _updatedValue({
    @required dynamic value,
    @required dynamic oldValue,
    @required dynamic linkedTo,
    @required dynamic oldLinkedTo,
  }) =>
      value ??
      ((linkedTo == null || linkedTo == oldLinkedTo) ? oldValue : null);

  Settings toSettings() => Settings(
        branchId: branch.id,
        callerId: person.id,
        categoryId: category.id,
        subcategoryId: subCategory.id,
        durationId: duration.id,
        operatorId: incidentOperator.id,
      );

  @override
  List<Object> get props => <Object>[
        categories,
        category,
        branch,
        durations,
        duration,
        incidentOperators,
        incidentOperator,
        person,
        subCategories,
        subCategory,
      ];

  @override
  String toString() => 'SettingsState {'
      'branch: $branch, '
      'person: $person, '
      'categories: $categories, '
      'category: $category, '
      'category: $subCategory, '
      'category: $subCategories, '
      'durations: $durations, '
      'duration: $duration, '
      'operators: $incidentOperators, '
      'operator: $incidentOperator, '
      '}';
}
