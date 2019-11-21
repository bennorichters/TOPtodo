import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class BranchSearchEvent extends Equatable {
  const BranchSearchEvent();
}

class SearchInfo extends Equatable {
  const SearchInfo({
    @required this.type,
    @required this.linkedTo,
    @required this.query,
  });
  final Type type;
  final Type linkedTo;
  final String query;

  @override
  List<Object> get props => <Object>[type, linkedTo, query];
}

abstract class SearchInfoEvent extends BranchSearchEvent {
  const SearchInfoEvent({@required this.searchInfo});
  final SearchInfo searchInfo;

  @override
  List<Object> get props => <Object>[searchInfo];
}

class BranchSearchFinishedQuery extends SearchInfoEvent {
  const BranchSearchFinishedQuery({@required SearchInfo searchInfo})
      : super(searchInfo: searchInfo);
}

class BranchSearchIncompleteQuery extends SearchInfoEvent {
  const BranchSearchIncompleteQuery({@required SearchInfo searchInfo})
      : super(searchInfo: searchInfo);
}
