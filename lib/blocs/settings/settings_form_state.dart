import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:toptodo_data/toptodo_data.dart';

/// State of the form the user fills with all settings
@immutable
class SettingsFormState extends Equatable {
  /// Creates an instance of [SettingsFormState]
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

  /// the filled in branch
  final TdBranch tdBranch;

  /// the filled in caller
  final TdCaller tdCaller;

  /// all categories
  final Iterable<TdCategory> tdCategories;

  /// the filled in category
  final TdCategory tdCategory;

  /// all durations
  final Iterable<TdDuration> tdDurations;

  /// the chose duration
  final TdDuration tdDuration;

  /// all operators
  final Iterable<TdOperator> tdOperators;

  /// the chosen operator
  final TdOperator tdOperator;

  /// all subcategories that belong the [tdCategory]
  final Iterable<TdSubcategory> tdSubcategories;

  /// the chosen subcategory
  final TdSubcategory tdSubcategory;

  /// Returns a new instance of [SettingsFormState] with updated values.
  ///
  /// The provided arguments are used as updated values for the returned new
  /// instance. For all fields that do not have an updated value the current
  /// value of `this` object is copied.
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

  /// Returns a new instance of [Settings] based on the values of `this` object.
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
      'subcategory: $tdSubcategory, '
      'subcategories: $tdSubcategories, '
      'durations: $tdDurations, '
      'duration: $tdDuration, '
      'operators: $tdOperators, '
      'operator: $tdOperator, '
      '}';
}
