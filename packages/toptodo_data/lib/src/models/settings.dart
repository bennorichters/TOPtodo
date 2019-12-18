import 'package:meta/meta.dart';
import 'package:toptodo_data/toptodo_data.dart';

class Settings {
  const Settings({
    @required this.branch,
    @required this.caller,
    @required this.category,
    @required this.subCategory,
    @required this.incidentDuration,
    @required this.incidentOperator,
  });

  final Branch branch;
  final Caller caller;
  final Category category;
  final SubCategory subCategory;
  final IncidentDuration incidentDuration;
  final IncidentOperator incidentOperator;

  @override
  String toString() => 'branch: $branch, '
      'caller: $caller, '
      'category: $category, '
      'subCategory: $subCategory, '
      'incidentDuration: $incidentDuration, '
      'incidentOperator: $incidentOperator';
}
