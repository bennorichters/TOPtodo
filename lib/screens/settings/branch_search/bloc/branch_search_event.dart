import 'package:equatable/equatable.dart';

abstract class BranchSearchEvent extends Equatable {
  const BranchSearchEvent();
}

class BranchSearchFinishedQuery extends BranchSearchEvent {
  const BranchSearchFinishedQuery(this.query);
  final String query;

  @override
  List<Object> get props => <Object>[query];
}

class BranchSearchIncompleteQuery extends BranchSearchEvent {
  const BranchSearchIncompleteQuery(this.query);
  final String query;

  @override
  List<Object> get props => <Object>[query];
}

