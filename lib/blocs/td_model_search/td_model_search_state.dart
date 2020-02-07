import 'package:equatable/equatable.dart';
import 'package:toptodo_data/toptodo_data.dart';

/// Base class for all search related states
abstract class TdModelSearchState extends Equatable {
  /// Creates an instance of [TdModelSearchState]
  const TdModelSearchState();

  @override
  List<Object> get props => [];
}

/// State emitted when the bloc is first initialized
class TdModelSearchInitialState extends TdModelSearchState {
  /// Creates an instance of [TdModelSearchInitialState]
  const TdModelSearchInitialState();
}

/// State emitted when the bloc started a search and is waiting for results.
class TdModelSearching extends TdModelSearchState {
  /// Creates an instance of [TdModelSearching]
  const TdModelSearching();
}

/// State emitted when the bloc received search results
class TdModelSearchResults<T extends TdModel> extends TdModelSearchState {
  /// Creates an instance of [TdModelSearchResults]
  const TdModelSearchResults(this.results);

  /// the search results
  final Iterable<T> results;

  @override
  List<Object> get props => super.props..addAll([results]);

  @override
  String toString() => 'TdModelSearchResults results: $results';
}
