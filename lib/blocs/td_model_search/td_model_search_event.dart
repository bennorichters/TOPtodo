import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:toptodo_data/toptodo_data.dart';

abstract class TdModelSearchEvent extends Equatable {
  const TdModelSearchEvent();

  @override
  List<Object> get props => [];
}

class NewSearch extends TdModelSearchEvent {
  const NewSearch();
}

abstract class SearchInfo<T extends TdModel> extends TdModelSearchEvent {
  const SearchInfo({
    @required this.linkedTo,
    @required this.query,
  });
  final TdModel linkedTo;
  final String query;

  @override
  List<Object> get props => super.props..addAll([linkedTo, query]);

  @override
  String toString() =>
      'TdModelSearchInfoEvent - linkedTo: $linkedTo query: $query';
}

class SearchFinishedQuery<T extends TdModel> extends SearchInfo<T> {
  const SearchFinishedQuery({
    @required TdModel linkedTo,
    @required String query,
  }) : super(linkedTo: linkedTo, query: query);
}

class SearchIncompleteQuery<T extends TdModel> extends SearchInfo<T> {
  const SearchIncompleteQuery({
    @required TdModel linkedTo,
    @required String query,
  }) : super(linkedTo: linkedTo, query: query);
}
