import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:toptodo/blocs/td_model_search/bloc.dart';
import 'package:toptodo_data/toptodo_data.dart';
import 'package:rxdart/rxdart.dart';

class TdModelSearchBloc extends Bloc<TdModelSearchEvent, TdModelSearchState> {
  TdModelSearchBloc({this.topdeskProvider});
  final TopdeskProvider topdeskProvider;
  final _Debouncer _debouncer = _Debouncer(
    duration: const Duration(milliseconds: 500),
  );

  @override
  TdModelSearchState get initialState => TdModelSearchInitialState();

  @override
  Stream<TdModelSearchState> mapEventToState(
    TdModelSearchEvent event,
  ) async* {
    BehaviorSubject<TdModelSearchState> controller;

    void addToController() async {
      if (event is TdModelNewSearch) {
        controller.add(initialState);
        await controller.close();
      } else if (event is TdModelSearchFinishedQuery) {
        controller.add(TdModelSearching());
        await controller.addStream(
          _queryBasedResults(searchInfo: event.searchInfo),
        );
        await controller.close();
      } else if (event is TdModelSearchIncompleteQuery) {
        controller.add(TdModelSearching());

        _debouncer.run(() async {
          await controller.addStream(
            _queryBasedResults(searchInfo: event.searchInfo),
          );
          await controller.close();
        });
      } else {
        await controller.close();
        throw ArgumentError('unknown event $event');
      }
    }

    controller = BehaviorSubject<TdModelSearchState>(onListen: addToController);
    yield* controller.stream;
  }

  Stream<TdModelSearchState> _queryBasedResults<T extends TdModel>(
      {SearchInfo<T> searchInfo}) async* {
    if (searchInfo is SearchInfo<Branch>) {
      yield TdModelSearchResults<Branch>(
        await topdeskProvider.branches(
          startsWith: searchInfo.query,
        ),
      );
    } else if (searchInfo is SearchInfo<Caller>) {
      yield TdModelSearchResults<Caller>(
        await topdeskProvider.callers(
          branch: searchInfo.linkedTo as Branch,
          startsWith: searchInfo.query,
        ),
      );
    } else if (searchInfo is SearchInfo<IncidentOperator>) {
      yield TdModelSearchResults<IncidentOperator>(
        await topdeskProvider.incidentOperators(
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
