import 'package:equatable/equatable.dart';
import 'package:toptodo_data/toptodo_data.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
}

class SettingsTdData extends SettingsState {
  const SettingsTdData({
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

class SettingsLogout extends SettingsState {
  @override
  List<Object> get props => <Object>[];
}
