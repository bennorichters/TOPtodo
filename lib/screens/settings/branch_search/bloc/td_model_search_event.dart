import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class TdModelSearchEvent extends Equatable {
  const TdModelSearchEvent();
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

abstract class TdModelSearchInfoEvent extends TdModelSearchEvent {
  const TdModelSearchInfoEvent({@required this.searchInfo});
  final SearchInfo searchInfo;

  @override
  List<Object> get props => <Object>[searchInfo];
}

class TdModelSearchFinishedQuery extends TdModelSearchInfoEvent {
  const TdModelSearchFinishedQuery({@required SearchInfo searchInfo})
      : super(searchInfo: searchInfo);
}

class TdModelSearchIncompleteQuery extends TdModelSearchInfoEvent {
  const TdModelSearchIncompleteQuery({@required SearchInfo searchInfo})
      : super(searchInfo: searchInfo);
}
