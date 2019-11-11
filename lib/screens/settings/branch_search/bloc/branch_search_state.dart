import 'package:equatable/equatable.dart';

abstract class BranchSearchState extends Equatable {
  const BranchSearchState();
}

class BranchSearchInitialState extends BranchSearchState {
  @override
  List<Object> get props => <Object> [];
}

class BranchSearchResults extends BranchSearchState {
  const BranchSearchResults(this.results);
  final List<String> results;

  @override
  List<Object> get props => null;
}
