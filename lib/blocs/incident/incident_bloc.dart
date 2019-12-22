import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:toptodo_data/toptodo_data.dart';
import './bloc.dart';

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
    if (event is IncidentShowSettingsEvent) {
      yield IncidentShowSettingsState();
    }
  }
}
