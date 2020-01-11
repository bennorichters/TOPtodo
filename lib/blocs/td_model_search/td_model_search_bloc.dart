import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:toptodo/blocs/td_model_search/bloc.dart';
import 'package:toptodo_data/toptodo_data.dart';

class TdModelSearchBloc extends Bloc<TdModelSearchEvent, TdModelSearchState> {
  TdModelSearchBloc({
    this.topdeskProvider,
    Duration debounceTime = const Duration(milliseconds: 500),
  }) : _debouncer = _Debouncer(duration: debounceTime);

  final TopdeskProvider topdeskProvider;
  final _Debouncer _debouncer;

  @override
  TdModelSearchState get initialState => TdModelSearchInitialState();

  @override
  Stream<TdModelSearchState> mapEventToState(
    TdModelSearchEvent event,
  ) async* {
    StreamController<TdModelSearchState> controller;

    void addToController() async {
      if (event is TdModelNewSearch) {
        controller.add(initialState);
        await controller.close();
      } else if (event is TdModelSearchFinishedQuery) {
        controller.add(TdModelSearching());
        await controller.addStream(
          _queryBasedResults(searchInfo: event),
        );
        await controller.close();
      } else if (event is TdModelSearchIncompleteQuery) {
        controller.add(TdModelSearching());

        _debouncer.run(() async {
          await controller.addStream(
            _queryBasedResults(searchInfo: event),
          );
          await controller.close();
        });
      } else {
        await controller.close();
        throw ArgumentError('unknown event $event');
      }
    }

    controller = StreamController<TdModelSearchState>(
      onListen: addToController,
    );
    yield* controller.stream;
  }

  Stream<TdModelSearchState> _queryBasedResults<T extends TdModel>(
      {TdModelSearchInfoEvent searchInfo}) async* {
    if (searchInfo is TdModelSearchInfoEvent<TdBranch>) {
      yield TdModelSearchResults<TdBranch>(
        await topdeskProvider.tdBranches(
          startsWith: searchInfo.query,
        ),
      );
    } else if (searchInfo is TdModelSearchInfoEvent<TdCaller>) {
      yield TdModelSearchResults<TdCaller>(
        await topdeskProvider.tdCallers(
          tdBranch: searchInfo.linkedTo as TdBranch,
          startsWith: searchInfo.query,
        ),
      );
    } else if (searchInfo is TdModelSearchInfoEvent<TdOperator>) {
      yield TdModelSearchResults<TdOperator>(
        await topdeskProvider.tdOperators(
          startsWith: searchInfo.query,
        ),
      );
    } else {
      throw ArgumentError('no search for $searchInfo');
    }
  }
}

class _Debouncer {
  _Debouncer({this.duration});

  final Duration duration;
  Timer _timer;

  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }
}
