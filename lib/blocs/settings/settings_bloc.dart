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
      final Settings settings = await settingsProvider.provide();
      _formState = SettingsFormState(
        branch: settings?.branch,
        caller: settings?.caller,
        category: settings?.category,
        subCategory: settings?.subCategory,
        duration: settings?.incidentDuration,
        incidentOperator: settings?.incidentOperator,
      );
      yield SettingsTdData(formState: _formState);

      final List<Iterable<TdModel>> searchListOptions = await Future.wait(
        <Future<Iterable<TdModel>>>[
          topdeskProvider.incidentDurations(),
          topdeskProvider.categories(),
        ],
      );

      _formState = _formState.update(
        updatedDurations: searchListOptions[0] as Iterable<IncidentDuration>,
        updatedCategories: searchListOptions[1] as Iterable<Category>,
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
      settingsProvider.save(_formState.toSettings());
    } else if (event is SettingsUserLoggedOut) {
      yield SettingsLogout(formState: _formState);
    } else {
      throw ArgumentError('unknown event $event');
    }
  }
}
