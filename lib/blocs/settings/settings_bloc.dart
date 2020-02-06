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
    try {
      if (event is SettingsInit) {
        yield SettingsLoading(
          currentOperator: await topdeskProvider.currentTdOperator(),
        );
        await _fillFormWithSettings();
        yield await _currentData();

        await _fillFormWithSearchLists();
        yield await _currentData();
      } else if (event is ValueSelected) {
        yield* _updateCurrentData(event);
      } else if (event is SettingsSave) {
        await settingsProvider.save(_formState.toSettings());
        yield SettingsSaved(
          currentOperator: await topdeskProvider.currentTdOperator(),
          formState: _formState,
        );
      }
    } catch (error, stackTrace) {
      yield SettingsError(error, stackTrace);
    }
  }

  Stream<SettingsState> _updateCurrentData(ValueSelected event) async* {
    if (event.tdBranch != null) {
      _formState = _formState.update(updatedTdBranch: event.tdBranch);
    } else if (event.tdCaller != null) {
      _formState = _formState.update(updatedTdCaller: event.tdCaller);
    } else if (event.tdCategory != null) {
      _formState = _formState.update(updatedTdCategory: event.tdCategory);
      yield await _currentData();

      _formState = _formState.update(
        updatedTdSubcategories: await topdeskProvider.tdSubcategories(
          tdCategory: event.tdCategory,
        ),
      );
    } else if (event.tdSubcategory != null) {
      _formState = _formState.update(updatedTdSubcategory: event.tdSubcategory);
    } else if (event.tdDuration != null) {
      _formState = _formState.update(updatedTdDuration: event.tdDuration);
    } else if (event.tdOperator != null) {
      _formState = _formState.update(updatedTdOperator: event.tdOperator);
    }

    yield await _currentData();
  }

  Future<void> _fillFormWithSettings() async {
    final settings = await settingsProvider.provide();
    final models = await Future.wait(
      [
        _modelOrNull(settings.tdBranchId, topdeskProvider.tdBranch),
        _modelOrNull(settings.tdCallerId, topdeskProvider.tdCaller),
        _modelOrNull(settings.tdCategoryId, topdeskProvider.tdCategory),
        _modelOrNull(settings.tdSubcategoryId, topdeskProvider.tdSubcategory),
        _modelOrNull(settings.tdDurationId, topdeskProvider.tdDuration),
        _modelOrNull(settings.tdOperatorId, topdeskProvider.tdOperator),
      ],
    );

    final TdBranch branch = models[0];
    final TdCaller caller = models[1];
    final TdCategory category = models[2];
    final TdSubcategory subcategory = models[3];
    final TdDuration tdDuration = models[4];
    final TdOperator tdOperator = models[5];

    _formState = SettingsFormState(
      tdBranch: branch,
      tdCaller: _paternityTest(
        caller,
        caller?.branch,
        branch,
      ),
      tdCategory: category,
      tdSubcategory: _paternityTest(
        subcategory,
        subcategory?.category,
        category,
      ),
      tdDuration: tdDuration,
      tdOperator: tdOperator,
    );
  }

  Future<UpdatedFormState> _currentData() async {
    final currentOperator = await topdeskProvider.currentTdOperator();
    if (_formState.tdOperator == null && currentOperator.firstLine) {
      _formState = _formState.update(updatedTdOperator: currentOperator);
    }

    return UpdatedFormState(
      currentOperator: currentOperator,
      formState: _formState,
    );
  }

  Future<TdModel> _modelOrNull(String id, ProvideModel method) async =>
      Future.value(
        id == null ? null : method(id: id),
      ).catchError(
        (error) {
          if (error is TdNotFoundException) {
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
      topdeskProvider.tdDurations(),
      topdeskProvider.tdCategories(),
    ];

    if (_formState.tdCategory != null) {
      searchLists.add(
        topdeskProvider.tdSubcategories(
          tdCategory: _formState.tdCategory,
        ),
      );
    }

    final searchListOptions = await Future.wait(searchLists);

    _formState = _formState.update(
      updatedTdDurations: searchListOptions[0],
      updatedTdCategories: searchListOptions[1],
      updatedTdSubcategories:
          _formState.tdCategory == null ? null : searchListOptions[2],
    );
  }
}
