import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
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
          _BranchSearchIncompleteQueryReady(searchInfo: event.searchInfo),
        ),
      );
    } else if (event is _BranchSearchIncompleteQueryReady) {
      yield await _queryBasedResults(searchInfo: event.searchInfo);
    } else {
      throw ArgumentError('unknown event $event');
    }
  }

  Future<TdModelSearchState> _queryBasedResults({SearchInfo searchInfo}) async {
    switch (searchInfo.type) {
      case Branch:
        return TdModelSearchResults(
          await topdeskProvider.fetchBranches(
            startsWith: searchInfo.query,
          ),
        );
      case Person:
        return TdModelSearchResults(
          await topdeskProvider.fetchPersons(
            branch: searchInfo.linkedTo,
            startsWith: searchInfo.query,
          ),
        );
      case Operator:
        return TdModelSearchResults(
          await topdeskProvider.fetchOperators(
            startsWith: searchInfo.query,
          ),
        );
      default:
        throw ArgumentError('no search for ${searchInfo.type}');
    }
  }
}

class _BranchSearchIncompleteQueryReady extends TdModelSearchInfoEvent {
  const _BranchSearchIncompleteQueryReady({@required SearchInfo searchInfo})
      : super(searchInfo: searchInfo);
}

class _Debouncer {
  _Debouncer({this.duration});

  final Duration duration;
  Timer _timer;

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }
}
