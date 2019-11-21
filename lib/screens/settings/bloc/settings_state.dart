import 'package:equatable/equatable.dart';
import 'package:toptodo_data/toptodo_data.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
}

class SettingsTdData extends SettingsState {
  const SettingsTdData({
    this.branch,
    this.durations,
    this.duration,
    this.person,
  });

  final Branch branch;
  final Iterable<IncidentDuration> durations;
  final IncidentDuration duration;
  final Person person;

  @override
  List<Object> get props => <Object>[
        branch,
        durations,
        duration,
        person,
      ];

  @override
  String toString() => 'SettingsState {'
      'branch: $branch, '
      'durations: $durations, '
      'duration: $duration, '
      'person: $person, '
      '}';
}
