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

  InitData _initData;

  @override
  InitState get initialState => const InitData.empty();

  @override
  Stream<InitState> mapEventToState(InitEvent event) async* {
    if (event is RequestInitData) {
      StreamController<InitState> controller;

      void addToController() async {
        final credentials = await credentialsProvider.provide();

        if (credentials.isComplete()) {
          _initData = InitData(credentials: credentials);
          controller.add(_initData);

          settingsProvider.init(credentials.url, credentials.loginName);
          topdeskProvider.init(credentials);

          _finishLoadingData(controller);
        } else {
          controller.add(IncompleteCredentials(credentials));
          await controller.close();
        }
      }

      controller = StreamController<InitState>(
        onListen: addToController,
      );

      yield* controller.stream;
    } else {
      throw ArgumentError('unexpected event $event');
    }
  }

  void _finishLoadingData(StreamController<InitState> controller) {
    settingsProvider.provide().then((value) async {
      controller.add(
        _initData = _initData.update(updatedSettings: value),
      );

      if (_initData.isComplete()) {
        await controller.close();
      }
    });

    topdeskProvider.currentIncidentOperator().then((value) async {
      controller.add(
        _initData = _initData.update(updatedCurrentOperator: value),
      );

      if (_initData.isComplete()) {
        await controller.close();
      }
    }).catchError((e) async {
      print('InitBloc - catchError: $e');
      controller.add(LoadingDataFailed(e));
      await controller.close();
    });
  }
}
