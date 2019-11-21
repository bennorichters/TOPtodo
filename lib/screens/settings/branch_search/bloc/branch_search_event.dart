import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class BranchSearchEvent extends Equatable {
  const BranchSearchEvent();
}

class BranchSearchFinishedQuery extends BranchSearchEvent {
  const BranchSearchFinishedQuery({
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

class BranchSearchIncompleteQuery extends BranchSearchEvent {
  const BranchSearchIncompleteQuery({
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
