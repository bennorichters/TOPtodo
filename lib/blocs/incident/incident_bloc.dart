import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class IncidentBloc extends Bloc<IncidentEvent, IncidentState> {
  @override
  IncidentState get initialState => InitialIncidentState();

  @override
  Stream<IncidentState> mapEventToState(
    IncidentEvent event,
  ) async* {
    if (event is IncidentShowSettingsEvent) {
      // yield 
    }
  }
}
