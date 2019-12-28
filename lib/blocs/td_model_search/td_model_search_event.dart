import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:toptodo_data/toptodo_data.dart';

abstract class TdModelSearchEvent extends Equatable {
  const TdModelSearchEvent();
}

class TdModelNewSearch extends TdModelSearchEvent {
  @override
  List<Object> get props => [];
}

abstract class TdModelSearchInfoEvent<T extends TdModel>
    extends TdModelSearchEvent {
  const TdModelSearchInfoEvent({
    @required this.linkedTo,
    @required this.query,
  });
  final TdModel linkedTo;
  final String query;

  @override
  List<Object> get props => [linkedTo, query];

  @override
  String toString() =>
      'TdModelSearchInfoEvent - linkedTo: $linkedTo query: $query';
}

class TdModelSearchFinishedQuery<T extends TdModel>
    extends TdModelSearchInfoEvent<T> {
  const TdModelSearchFinishedQuery({
    @required TdModel linkedTo,
    @required String query,
  }) : super(linkedTo: linkedTo, query: query);
}

class TdModelSearchIncompleteQuery<T extends TdModel>
    extends TdModelSearchInfoEvent<T> {
  const TdModelSearchIncompleteQuery({
    @required TdModel linkedTo,
    @required String query,
  }) : super(linkedTo: linkedTo, query: query);
}
