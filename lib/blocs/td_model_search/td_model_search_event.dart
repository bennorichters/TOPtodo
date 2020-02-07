import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:toptodo_data/toptodo_data.dart';

/// Base class for all events related to search
abstract class TdModelSearchEvent extends Equatable {
  /// Creates a new instance of [TdModelSearchEvent]
  const TdModelSearchEvent();

  @override
  List<Object> get props => [];
}

/// Event to notify the bloc that a new search will start
class NewSearch extends TdModelSearchEvent {
  /// Creates a new instance of [NewSearch]
  const NewSearch();
}

/// Base class for all events that contain search related information
abstract class SearchInfo<T extends TdModel> extends TdModelSearchEvent {
  /// Creates a new instance of [SearchInfo]
  const SearchInfo({
    @required this.linkedTo,
    @required this.query,
  });

  /// the parent model of the model to look for
  final TdModel linkedTo;

  /// the search query
  final String query;

  @override
  List<Object> get props => super.props..addAll([linkedTo, query]);

  @override
  String toString() =>
      'TdModelSearchInfoEvent - linkedTo: $linkedTo query: $query';
}

/// Event with information of a finished search query
class SearchFinishedQuery<T extends TdModel> extends SearchInfo<T> {
  /// Creates a new instance of [SearchFinishedQuery]
  const SearchFinishedQuery({
    @required TdModel linkedTo,
    @required String query,
  }) : super(linkedTo: linkedTo, query: query);
}

/// Event with information of a search query that might not yet be finished
class SearchIncompleteQuery<T extends TdModel> extends SearchInfo<T> {
  /// Creates a new instance of [SearchIncompleteQuery]
  const SearchIncompleteQuery({
    @required TdModel linkedTo,
    @required String query,
  }) : super(linkedTo: linkedTo, query: query);
}
