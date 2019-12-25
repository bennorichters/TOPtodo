import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:toptodo/blocs/incident/bloc.dart';
import 'package:toptodo_data/toptodo_data.dart';

class IncidentBloc extends Bloc<IncidentEvent, IncidentState> {
  IncidentBloc({
    @required this.topdeskProvider,
    @required this.settingsProvider,
  });
  final TopdeskProvider topdeskProvider;
  final SettingsProvider settingsProvider;

  @override
  IncidentState get initialState => InitialIncidentState();

  @override
  Stream<IncidentState> mapEventToState(
    IncidentEvent event,
  ) async* {
    if (event is IncidentSubmit) {
      yield SubmittingIncident();
      
      final number = await topdeskProvider.createIncident(
        briefDescription: event.briefDescription,
        request: event.request.isEmpty ? null : event.request,
        settings: await settingsProvider.provide(),
      );

      yield IncidentCreated(number);
    }
  }
}
