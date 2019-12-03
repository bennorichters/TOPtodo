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
  SettingsFormState _formState = const SettingsFormState();

  @override
  SettingsState get initialState => SettingsTdData(formState: _formState);

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is SettingsInit) {
      yield SettingsTdData(formState: _formState);

      final List<Iterable<TdModel>> searchListOptions =
          await Future.wait(<Future<Iterable<TdModel>>>[
        topdeskProvider.fetchDurations(),
        topdeskProvider.fetchCategories(),
        topdeskProvider.fetchOperators(),
      ]);

      _formState = SettingsFormState(
        durations: searchListOptions[0],
        categories: searchListOptions[1],
        incidentOperators: searchListOptions[2],
      );

      yield SettingsTdData(formState: _formState);
    } else if (event is SettingsCategorySelected) {
      _formState = _formState.update(updatedCategory: event.category);
      yield SettingsTdData(formState: _formState);

      final Iterable<SubCategory> subCategories =
          await topdeskProvider.fetchSubCategories(
        category: event.category,
      );

      _formState = _formState.update(updatedSubCategories: subCategories);
      yield SettingsTdData(formState: _formState);
    } else if (event is SettingsDurationSelected) {
      _formState = _formState.update(updatedDuration: event.duration);
      yield SettingsTdData(formState: _formState);
    } else if (event is SettingsBranchSelected) {
      _formState = _formState.update(updatedBranch: event.branch);
      yield SettingsTdData(formState: _formState);
    } else if (event is SettingsOperatorSelected) {
      _formState =
          _formState.update(updatedIncidentOperator: event.incidentOperator);
      yield SettingsTdData(formState: _formState);
    } else if (event is SettingsPersonSelected) {
      _formState = _formState.update(updatedPerson: event.person);
      yield SettingsTdData(formState: _formState);
    } else if (event is SettingsSubCategorySelected) {
      _formState = _formState.update(updatedSubCategory: event.subCategory);
      yield SettingsTdData(formState: _formState);
    } else if (event is SettingsSave) {
      settingsProvider.save(_formState.toSettings());
    } else if (event is SettingsUserLoggedOut) {
      yield SettingsLogout(formState: _formState);
    } else {
      throw ArgumentError('unknown event $event');
    }
  }
}
