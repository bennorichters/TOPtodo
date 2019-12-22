import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:toptodo_data/toptodo_data.dart';

import './bloc.dart';

class TdModelSearchBloc extends Bloc<TdModelSearchEvent, TdModelSearchState> {
  TdModelSearchBloc(this.topdeskProvider);
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
    if (event is TdModelSearchFinishedQuery) {
      yield TdModelSearching();
      yield await _queryBasedResults(searchInfo: event.searchInfo);
    } else if (event is TdModelSearchIncompleteQuery) {
      yield TdModelSearching();

      _debouncer.run(
        () => add(
          _SearchIncompleteQueryReady<TdModel>(searchInfo: event.searchInfo),
        ),
      );
    } else if (event is _SearchIncompleteQueryReady) {
      yield await _queryBasedResults(searchInfo: event.searchInfo);
    } else {
      throw ArgumentError('unknown event $event');
    }
  }

  Future<TdModelSearchResults<TdModel>> _queryBasedResults<T extends TdModel>(
      {SearchInfo<T> searchInfo}) async {
    if (searchInfo is SearchInfo<Branch>) {
      return TdModelSearchResults<Branch>(
        await topdeskProvider.branches(
          startsWith: searchInfo.query,
        ),
      );
    } else if (searchInfo is SearchInfo<Caller>) {
      return TdModelSearchResults<Caller>(
        await topdeskProvider.callers(
          branch: searchInfo.linkedTo as Branch,
          startsWith: searchInfo.query,
        ),
      );
    } else if (searchInfo is SearchInfo<IncidentOperator>) {
      return TdModelSearchResults<IncidentOperator>(
        await topdeskProvider.incidentOperators(
          startsWith: searchInfo.query,
        ),
      );
    } else {
      throw ArgumentError('no search for $searchInfo');
    }
  }
}

class _SearchIncompleteQueryReady<T extends TdModel>
    extends TdModelSearchInfoEvent<T> {
  const _SearchIncompleteQueryReady({@required SearchInfo<T> searchInfo})
      : super(searchInfo: searchInfo);
}

class _Debouncer {
  _Debouncer({this.duration});

  final Duration duration;
  Timer _timer;

  void run(void action()) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }
}
