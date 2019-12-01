import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:toptodo/blocs/settings/bloc.dart';
import 'package:toptodo_data/toptodo_data.dart';

import './bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    @required this.topdeskProvider,
    @required this.settingsProvider,
  });
  final TopdeskProvider topdeskProvider;
  final SettingsProvider settingsProvider;

  @override
  SettingsState get initialState => const SettingsTdData();

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is SettingsInit) {
      yield const SettingsTdData();

      final List<Iterable<TdModel>> searchListOptions =
          await Future.wait(<Future<Iterable<TdModel>>>[
        topdeskProvider.fetchDurations(),
        topdeskProvider.fetchCategories(),
      ]);

      yield SettingsTdData(
        formState: SettingsFormState(
          durations: searchListOptions[0],
          categories: searchListOptions[1],
        ),
      );
    } else if (event is SettingsCategorySelected) {
      yield _updatedState(category: event.category);
      final Iterable<SubCategory> subCategories =
          await topdeskProvider.fetchSubCategories(
        category: event.category,
      );

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
    } else if (event is SettingsSave) {
      final SettingsState oldState = state;

      if (oldState is SettingsTdData) {
        final SettingsFormState sfs = oldState.formState;
        settingsProvider.save(
          Settings(
            branchId: sfs.branch.id,
            callerId: sfs.person.id,
            categoryId: sfs.category.id,
            subcategoryId: sfs.subCategory.id,
            durationId: sfs.duration.id,
            operatorId: '',
          ),
        );
      }
    } else if (event is SettingsUserLoggedOut) {
      yield SettingsLogout();
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
      final SettingsFormState sfs = oldState.formState;
      return SettingsTdData(
        formState: SettingsFormState(
          branch: branch ?? sfs.branch,
          categories: categories ?? sfs.categories,
          category: category ?? sfs.category,
          durations: durations ?? sfs.durations,
          duration: duration ?? sfs.duration,
          person: _updatedValue(
            value: person,
            oldValue: sfs.person,
            linkedTo: branch,
            oldLinkedTo: sfs.branch,
          ),
          subCategories: _updatedValue(
            value: subCategories,
            oldValue: sfs.subCategories,
            linkedTo: category,
            oldLinkedTo: sfs.category,
          ),
          subCategory: _updatedValue(
            value: subCategory,
            oldValue: sfs.subCategory,
            linkedTo: category,
            oldLinkedTo: sfs.category,
          ),
        ),
      );
    }

    throw StateError('unexpected state: $oldState');
  }

  dynamic _updatedValue({
    @required dynamic value,
    @required dynamic oldValue,
    @required dynamic linkedTo,
    @required dynamic oldLinkedTo,
  }) =>
      value ??
      ((linkedTo == null || linkedTo == oldLinkedTo) ? oldValue : null);
}
