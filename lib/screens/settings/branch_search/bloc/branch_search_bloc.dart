import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:toptopdo/data/model/topdesk_elements.dart';
import 'package:toptopdo/data/topdesk_api_provider.dart';
import './bloc.dart';

class BranchSearchBloc extends Bloc<BranchSearchEvent, BranchSearchState> {
  BranchSearchBloc(this.topdeskProvider);
  final TopdeskProvider topdeskProvider;

  @override
  BranchSearchState get initialState => BranchSearchInitialState();

  @override
  Stream<BranchSearchState> mapEventToState(
    BranchSearchEvent event,
  ) async* {
    if (event is BranchSearchQuery) {
      final List<Branch> results =
          await topdeskProvider.fetchBranches(event.query);
      yield BranchSearchResults(results);
    }
  }
}
