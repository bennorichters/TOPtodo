import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:toptodo_data/toptodo_data.dart';

import './bloc.dart';

class BranchSearchBloc extends Bloc<BranchSearchEvent, BranchSearchState> {
  BranchSearchBloc(this.topdeskProvider);
  final TopdeskProvider topdeskProvider;
  final _Debouncer _debouncer = _Debouncer(
    duration: const Duration(milliseconds: 500),
  );

  @override
  BranchSearchState get initialState => BranchSearchInitialState();

  @override
  Stream<BranchSearchState> mapEventToState(
    BranchSearchEvent event,
  ) async* {
    if (event is BranchSearchFinishedQuery) {
      yield BranchSearchSearching();
      yield await _queryBasedResults(searchInfo: event.searchInfo);
    } else if (event is BranchSearchIncompleteQuery) {
      yield BranchSearchSearching();

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

  Future<BranchSearchState> _queryBasedResults({SearchInfo searchInfo}) async {
    final Iterable<Branch> results =
        await topdeskProvider.fetchBranches(startsWith: searchInfo.query);

    return BranchSearchResults(results);
  }
}

class _BranchSearchIncompleteQueryReady extends SearchInfoEvent {
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
