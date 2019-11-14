import 'package:equatable/equatable.dart';
import 'package:toptopdo/models/topdesk_elements.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
}

class SettingsTdData extends SettingsState {
  const SettingsTdData({
    this.branch,
    this.durations,
    this.duration,
  });

  final Branch branch;
  final Iterable<IncidentDuration> durations;
  final IncidentDuration duration;

  @override
  List<Object> get props => <Object>[
        branch,
        durations,
        duration,
      ];

  @override
  String toString() => 'SettingsState {'
      'branch: $branch, '
      'durations: $durations, '
      'duration: $duration, '
      '}';
}
