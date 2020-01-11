import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:toptodo_data/toptodo_data.dart';

import 'package:toptodo/blocs/incident/bloc.dart';

class IncidentBloc extends Bloc<IncidentEvent, IncidentState> {
  IncidentBloc({
    @required this.topdeskProvider,
    @required this.settingsProvider,
  });
  final TopdeskProvider topdeskProvider;
  final SettingsProvider settingsProvider;

  @override
  IncidentState get initialState => const InitialIncidentState();

  @override
  Stream<IncidentState> mapEventToState(
    IncidentEvent event,
  ) async* {
    if (event is IncidentShowForm) {
      yield OperatorLoaded(
        currentOperator: await topdeskProvider.currentTdOperator(),
      );
    } else if (event is IncidentSubmit) {
      final currentOperator = await topdeskProvider.currentTdOperator();

      yield SubmittingIncident(currentOperator: currentOperator);

      try {
        final number = await topdeskProvider.createTdIncident(
          briefDescription: event.briefDescription,
          request: event.request.isEmpty ? null : event.request,
          settings: await settingsProvider.provide(),
        );

        yield IncidentCreated(number: number, currentOperator: currentOperator);
      } catch (error) {
        yield IncidentCreationError(
          cause: error,
          currentOperator: currentOperator,
        );
      }
    }
  }
}
