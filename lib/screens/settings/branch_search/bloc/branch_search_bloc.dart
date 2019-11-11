import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class BranchSearchBloc extends Bloc<BranchSearchEvent, BranchSearchState> {
  @override
  BranchSearchState get initialState => BranchSearchInitialState();

  @override
  Stream<BranchSearchState> mapEventToState(
    BranchSearchEvent event,
  ) async* {
    if (event is BranchSearchQuery) {
      yield const BranchSearchResults(
        <String>[
          'Amsterdam',
          'Rotterdam',
          'Delft',
        ],
      );
    }
  }
}
