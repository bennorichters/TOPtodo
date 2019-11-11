import 'package:equatable/equatable.dart';

abstract class BranchSearchEvent extends Equatable {
  const BranchSearchEvent();
}

class BranchSearchQuery extends BranchSearchEvent {
  const BranchSearchQuery(this.query);
  final String query;

  @override
  List<Object> get props => <Object> [query];
}
