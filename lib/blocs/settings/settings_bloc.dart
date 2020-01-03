import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:toptodo/blocs/settings/bloc.dart';
import 'package:toptodo_data/toptodo_data.dart';

typedef ProvideModel = Future<TdModel> Function({String id});

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    @required this.topdeskProvider,
    @required this.settingsProvider,
  });
  final TopdeskProvider topdeskProvider;
  final SettingsProvider settingsProvider;
  SettingsFormState _formState;

  @override
  SettingsState get initialState => const InitialSettingsState();

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is SettingsInit) {
      yield SettingsLoading(
        currentOperator: await topdeskProvider.currentIncidentOperator(),
      );
      await _fillFormWithSettings();
      yield await _currentData();

      await _fillFormWithSearchLists();
      yield await _currentData();
    } else if (event is SettingsCategorySelected) {
      _formState = _formState.update(
        updatedCategory: event.category,
      );
      yield await _currentData();

      _formState = _formState.update(
        updatedSubCategories:
            await topdeskProvider.subCategories(category: event.category),
      );
      yield await _currentData();
    } else if (event is SettingsDurationSelected) {
      _formState = _formState.update(updatedDuration: event.duration);
      yield await _currentData();
    } else if (event is SettingsBranchSelected) {
      _formState = _formState.update(updatedBranch: event.branch);
      yield await _currentData();
    } else if (event is SettingsOperatorSelected) {
      _formState = _formState.update(updatedIncidentOperator: event.incidentOperator);
      yield await _currentData();
    } else if (event is SettingsCallerSelected) {
      _formState = _formState.update(updatedCaller: event.caller);
      yield await _currentData();
    } else if (event is SettingsSubCategorySelected) {
      _formState = _formState.update(updatedSubCategory: event.subCategory);
      yield await _currentData();
    } else if (event is SettingsSave) {
      await settingsProvider.save(_formState.toSettings());
      yield SettingsSaved(
        currentOperator: await topdeskProvider.currentIncidentOperator(),
        formState: _formState,
      );
    } else {
      throw ArgumentError('unknown event $event');
    }
  }

  Future<void> _fillFormWithSettings() async {
    final settings = await settingsProvider.provide();
    final models = await Future.wait(
      [
        _modelOrNull(settings.branchId, topdeskProvider.branch),
        _modelOrNull(settings.callerId, topdeskProvider.caller),
        _modelOrNull(settings.categoryId, topdeskProvider.category),
        _modelOrNull(settings.subCategoryId, topdeskProvider.subCategory),
        _modelOrNull(
            settings.incidentDurationId, topdeskProvider.incidentDuration),
        _modelOrNull(
            settings.incidentOperatorId, topdeskProvider.incidentOperator),
      ],
    );

    final Branch branch = models[0];
    final Caller caller = models[1];
    final Category category = models[2];
    final SubCategory subCategory = models[3];
    final IncidentDuration incidentDuration = models[4];
    final IncidentOperator incidentOperator = models[5];

    _formState = SettingsFormState(
      branch: branch,
      caller: _paternityTest(caller, caller?.branch, branch),
      category: category,
      subCategory: _paternityTest(subCategory, subCategory?.category, category),
      incidentDuration: incidentDuration,
      incidentOperator: incidentOperator,
    );
  }

  Future<SettingsTdData> _currentData() async {
    final currentOperator = await topdeskProvider.currentIncidentOperator();
    if (_formState.incidentOperator == null && currentOperator.firstLine) {
      _formState = _formState.update(updatedIncidentOperator: currentOperator);
    }

    return SettingsTdData(
      currentOperator: currentOperator,
      formState: _formState,
    );
  }

  Future<TdModel> _modelOrNull(String id, ProvideModel method) async =>
      Future.value(
        id == null ? null : method(id: id),
      ).catchError(
        (error) {
          if (error is TdModelNotFoundException) {
            return null;
          }
        },
      );

  TdModel _paternityTest(
    TdModel child,
    TdModel realParent,
    TdModel parentToTest,
  ) =>
      (realParent == parentToTest) ? child : null;

  Future _fillFormWithSearchLists() async {
    final searchLists = [
      topdeskProvider.incidentDurations(),
      topdeskProvider.categories(),
    ];

    if (_formState.category != null) {
      searchLists.add(
        topdeskProvider.subCategories(
          category: _formState.category,
        ),
      );
    }

    final searchListOptions = await Future.wait(searchLists);

    _formState = _formState.update(
      updatedDurations: searchListOptions[0],
      updatedCategories: searchListOptions[1],
      updatedSubCategories:
          _formState.category == null ? null : searchListOptions[2],
    );
  }
}
