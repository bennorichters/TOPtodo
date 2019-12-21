import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:toptodo_data/toptodo_data.dart';

class Settings extends Equatable {
  const Settings({
    @required this.branch,
    @required this.caller,
    @required this.category,
    @required this.subCategory,
    @required this.incidentDuration,
    @required this.incidentOperator,
  });

  const Settings.empty()
      : branch = null,
        caller = null,
        category = null,
        subCategory = null,
        incidentDuration = null,
        incidentOperator = null;

  final Branch branch;
  final Caller caller;
  final Category category;
  final SubCategory subCategory;
  final IncidentDuration incidentDuration;
  final IncidentOperator incidentOperator;

  bool isComplete() =>
      branch != null &&
      caller != null &&
      category != null &&
      subCategory != null &&
      incidentDuration != null &&
      incidentOperator != null;

  @override
  List<Object> get props => <Object>[
        branch,
        caller,
        category,
        subCategory,
        incidentDuration,
        incidentOperator,
      ];

  @override
  String toString() => 'branch: $branch, '
      'caller: $caller, '
      'category: $category, '
      'subCategory: $subCategory, '
      'incidentDuration: $incidentDuration, '
      'incidentOperator: $incidentOperator';
}
