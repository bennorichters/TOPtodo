import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:toptodo_data/toptodo_data.dart';

abstract class TdModelSearchEvent extends Equatable {
  const TdModelSearchEvent();
}

class SearchInfo<T extends TdModel> extends Equatable {
  const SearchInfo({
    @required this.linkedTo,
    @required this.query,
  });
  final TdModel linkedTo;
  final String query;

  @override
  List<Object> get props => <Object>[linkedTo, query];
}

abstract class TdModelSearchInfoEvent<T extends TdModel>
    extends TdModelSearchEvent {
  const TdModelSearchInfoEvent({@required this.searchInfo});
  final SearchInfo<T> searchInfo;

  @override
  List<Object> get props => <Object>[searchInfo];
}

class TdModelSearchFinishedQuery<T extends TdModel>
    extends TdModelSearchInfoEvent<T> {
  const TdModelSearchFinishedQuery({@required SearchInfo<T> searchInfo})
      : super(searchInfo: searchInfo);
}

class TdModelSearchIncompleteQuery<T extends TdModel>
    extends TdModelSearchInfoEvent<T> {
  const TdModelSearchIncompleteQuery({@required SearchInfo<T> searchInfo})
      : super(searchInfo: searchInfo);
}
