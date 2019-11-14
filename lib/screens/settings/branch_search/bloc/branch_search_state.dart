import 'package:equatable/equatable.dart';
import 'package:toptopdo/models/topdesk_elements.dart';

abstract class BranchSearchState extends Equatable {
  const BranchSearchState();
}

class BranchSearchInitialState extends BranchSearchState {
  @override
  List<Object> get props => <Object> [];
}

 class BranchSearchSearching extends BranchSearchState {
  @override
  List<Object> get props => <Object> [];
 }

class BranchSearchResults extends BranchSearchState {
  const BranchSearchResults(this.results);
  final Iterable<Branch> results;

  @override
  List<Object> get props => <Object> [results];
}
