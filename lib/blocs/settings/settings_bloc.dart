import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:toptodo_data/toptodo_data.dart';

import './bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this.topdeskProvider);

  final TopdeskProvider topdeskProvider;

  @override
  SettingsState get initialState => const SettingsTdData();

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is SettingsInit) {
      final List<Iterable<TdModel>> searchListOptions =
          await Future.wait(<Future<Iterable<TdModel>>>[
        topdeskProvider.fetchDurations(),
        topdeskProvider.fetchCategories(),
      ]);

      yield _updatedState(
        durations: searchListOptions[0],
        categories: searchListOptions[1],
      );
    } else if (event is SettingsDurationSelected) {
      yield _updatedState(duration: event.duration);
    } else if (event is SettingsBranchSelected) {
      yield _updatedState(branch: event.branch);
    } else if (event is SettingsPersonSelected) {
      yield _updatedState(person: event.person);
    } else {
      throw ArgumentError('unknown event $event');
    }
  }

  SettingsTdData _updatedState({
    Branch branch,
    Iterable<Category> categories,
    Iterable<IncidentDuration> durations,
    IncidentDuration duration,
    Person person,
  }) {
    final SettingsState oldState = state;
    if (oldState is SettingsTdData) {
      return SettingsTdData(
        branch: branch ?? oldState.branch,
        categories: categories ?? oldState.categories,
        durations: durations ?? oldState.durations,
        duration: duration ?? oldState.duration,
        person: person ??
            ((branch == null || branch == oldState.branch)
                ? oldState.person
                : null),
      );
    }

    throw StateError('unexpected state: $oldState');
  }
}
