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
    } else if (event is SettingsCategorySelected) {
      yield _updatedState(category: event.category);
      final Iterable<SubCategory> subCategories =
          await topdeskProvider.fetchSubCategories(
        category: event.category,
      );

      print('found subCategories: $subCategories');

      yield _updatedState(
        subCategories: subCategories,
      );
    } else if (event is SettingsDurationSelected) {
      yield _updatedState(duration: event.duration);
    } else if (event is SettingsBranchSelected) {
      yield _updatedState(branch: event.branch);
    } else if (event is SettingsPersonSelected) {
      yield _updatedState(person: event.person);
    } else if (event is SettingsSubCategorySelected) {
      yield _updatedState(subCategory: event.subCategory);
    } else {
      throw ArgumentError('unknown event $event');
    }
  }

  SettingsTdData _updatedState({
    Branch branch,
    Iterable<Category> categories,
    Category category,
    Iterable<IncidentDuration> durations,
    IncidentDuration duration,
    Person person,
    Iterable<SubCategory> subCategories,
    SubCategory subCategory,
  }) {
    final SettingsState oldState = state;
    if (oldState is SettingsTdData) {
      return SettingsTdData(
        branch: branch ?? oldState.branch,
        categories: categories ?? oldState.categories,
        category: category ?? oldState.category,
        durations: durations ?? oldState.durations,
        duration: duration ?? oldState.duration,
        person: person ?? _childValue(oldState.person, branch, oldState.branch),
        subCategories: subCategories ?? oldState.subCategories,
        subCategory: subCategory ??
            _childValue(oldState.subCategory, category, oldState.category),
      );
    }

    throw StateError('unexpected state: $oldState');
  }

  TdModel _childValue(TdModel oldChild, TdModel linkedTo, TdModel oldLinkedTo) {
    final TdModel updated =
        (linkedTo == null || linkedTo == oldLinkedTo) ? oldChild : null;

    // print('$oldChild, $linkedTo, $oldLinkedTo, $updated');

    return updated;
  }
}
