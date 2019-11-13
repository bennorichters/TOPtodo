import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:toptopdo/data/model/topdesk_elements.dart';
import 'package:toptopdo/data/topdesk_api_provider.dart';
import './bloc.dart';

class BranchSearchBloc extends Bloc<BranchSearchEvent, BranchSearchState> {
  BranchSearchBloc(this.topdeskProvider);
  final TopdeskProvider topdeskProvider;

  final _Debouncer _debouncer = _Debouncer(milliseconds: 500);

  @override
  BranchSearchState get initialState => BranchSearchInitialState();

  @override
  Stream<BranchSearchState> mapEventToState(
    BranchSearchEvent event,
  ) async* {
    if (event is BranchSearchFinishedQuery) {
      yield BranchSearchSearching();
      final Iterable<Branch> results =
          await topdeskProvider.fetchBranches(event.query);

      yield BranchSearchResults(results);
    } else if (event is BranchSearchIncompleteQuery) {
      yield BranchSearchSearching();

      _debouncer.run(() => add(_BranchSearchDoIncompleteQuery(event.query)));
    } else if (event is _BranchSearchDoIncompleteQuery) {
      final Iterable<Branch> results =
          await topdeskProvider.fetchBranches(event.query);

      yield BranchSearchResults(results);
    } else {
      throw ArgumentError('unknown event $event');
    }
  }
}

class _BranchSearchDoIncompleteQuery extends BranchSearchEvent {
  const _BranchSearchDoIncompleteQuery(this.query);
  final String query;

  @override
  List<Object> get props => <Object>[query];
}

class _Debouncer {
  _Debouncer({this.milliseconds});

  final int milliseconds;
  Timer _timer;

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
