import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:toptodo_data/toptodo_data.dart';

import 'package:toptodo/blocs/incident/bloc.dart';

/// Business logic component for creating incidents
class IncidentBloc extends Bloc<IncidentEvent, IncidentState> {
  /// Creates an incidents of [IncidentBloc]
  IncidentBloc({
    @required this.topdeskProvider,
    @required this.settingsProvider,
  });

  /// the [TopdeskProvider]
  final TopdeskProvider topdeskProvider;

  /// the [SettingsProvider]
  final SettingsProvider settingsProvider;

  TdOperator _currentOperator;

  @override
  IncidentState get initialState => const IncidentState(currentOperator: null);

  @override
  Stream<IncidentState> mapEventToState(
    IncidentEvent event,
  ) async* {
    if (event is IncidentInit) {
      _currentOperator = await topdeskProvider.currentTdOperator();
      yield IncidentState(currentOperator: _currentOperator);
    } else if (event is IncidentSubmit) {
      yield IncidentSubmitted(currentOperator: _currentOperator);

      try {
        final results = await Future.wait([
          topdeskProvider.createTdIncident(
            briefDescription: event.briefDescription,
            request: event.request.isEmpty ? null : event.request,
            settings: await settingsProvider.provide(),
          ),
          topdeskProvider.currentTdOperator(),
        ]);

        final number = results[0];
        _currentOperator = results[1];

        yield IncidentCreated(
          number: number,
          currentOperator: _currentOperator,
        );
      } catch (error, stackTrace) {
        yield IncidentCreationError(
          cause: error,
          stackTrace: stackTrace,
          currentOperator: _currentOperator,
        );
      }
    }
  }
}
