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
        topdeskProvider.incidentDurations(),
        topdeskProvider.categories(),
      ]);

      _formState = SettingsFormState(
        durations: searchListOptions[0],
        categories: searchListOptions[1],
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
