import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
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
  SettingsFormState _formState;

  @override
  SettingsState get initialState => SettingsLoading();

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is SettingsInit) {
      final settings = await settingsProvider.provide();
      _formState = SettingsFormState(
        branch: settings.branch,
        caller: settings.caller,
        category: settings.category,
        subCategory: settings.subCategory,
        duration: settings.incidentDuration,
        incidentOperator: settings.incidentOperator,
      );
      yield SettingsTdData(formState: _formState);

      final searchLists = [
        topdeskProvider.incidentDurations(),
        topdeskProvider.categories(),
      ];

      if (settings.category != null) {
        searchLists.add(
          topdeskProvider.subCategories(
            category: settings.category,
          ),
        );
      }

      final searchListOptions = await Future.wait(searchLists);

      _formState = _formState.update(
        updatedDurations: searchListOptions[0],
        updatedCategories: searchListOptions[1],
        updatedSubCategories:
            settings.category == null ? null : searchListOptions[2],
      );

      yield SettingsTdData(formState: _formState);
    } else if (event is SettingsCategorySelected) {
      yield SettingsTdData(
        formState: _formState = _formState.update(
          updatedCategory: event.category,
        ),
      );
      yield SettingsTdData(
        formState: _formState = _formState.update(
          updatedSubCategories: await topdeskProvider.subCategories(
            category: event.category,
          ),
        ),
      );
    } else if (event is SettingsDurationSelected) {
      yield SettingsTdData(
        formState: _formState = _formState.update(
          updatedDuration: event.duration,
        ),
      );
    } else if (event is SettingsBranchSelected) {
      yield SettingsTdData(
        formState: _formState = _formState.update(
          updatedBranch: event.branch,
        ),
      );
    } else if (event is SettingsOperatorSelected) {
      yield SettingsTdData(
        formState: _formState = _formState.update(
          updatedIncidentOperator: event.incidentOperator,
        ),
      );
    } else if (event is SettingsCallerSelected) {
      yield SettingsTdData(
        formState: _formState = _formState.update(
          updatedCaller: event.caller,
        ),
      );
    } else if (event is SettingsSubCategorySelected) {
      yield SettingsTdData(
        formState: _formState = _formState.update(
          updatedSubCategory: event.subCategory,
        ),
      );
    } else if (event is SettingsSave) {
      await settingsProvider.save(_formState.toSettings());
      yield SettingsSaved(formState: _formState);
    } else {
      throw ArgumentError('unknown event $event');
    }
  }
}
