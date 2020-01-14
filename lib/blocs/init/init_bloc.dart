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

          _finishLoadingData(controller, credentials);
        } else {
          controller.add(IncompleteCredentials(credentials));
          await controller.close();
        }
      }

      controller = StreamController<InitState>(
        onListen: addToController,
      );

      yield* controller.stream;
    }
  }

  void _finishLoadingData(
    StreamController<InitState> controller,
    Credentials credentials,
  ) {
    settingsProvider.init(credentials.url, credentials.loginName);
    settingsProvider.provide().then((value) async {
      if (!controller.isClosed) {
        controller.add(
          _initData = _initData.update(updatedSettings: value),
        );
      }

      if (_initData.isComplete()) {
        await controller.close();
      }
    });

    topdeskProvider
        .init(credentials)
        .then((_) => topdeskProvider.currentTdOperator())
        .then((tdOperator) async {
      controller.add(
        _initData = _initData.update(updatedCurrentOperator: tdOperator),
      );

      if (_initData.isComplete()) {
        await controller.close();
      }
    }).catchError((e) async {
      controller.add(LoadingDataFailed(e));
      await controller.close();
    });
  }
}
