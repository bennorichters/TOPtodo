import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:toptodo/blocs/init/bloc.dart';
import 'package:toptodo_data/toptodo_data.dart';

class InitBloc extends Bloc<InitEvent, InitState> {
  InitBloc({
    @required this.credentialsProvider,
    @required this.topdeskProvider,
    @required this.settingsProvider,
  });

  final CredentialsProvider credentialsProvider;
  final TopdeskProvider topdeskProvider;
  final SettingsProvider settingsProvider;

  @override
  InitState get initialState => const LoadingInitData.empty();

  @override
  Stream<InitState> mapEventToState(InitEvent event) async* {
    yield LoadingInitData.empty();
  }
}
