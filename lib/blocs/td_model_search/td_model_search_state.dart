import 'package:equatable/equatable.dart';
import 'package:toptodo_data/toptodo_data.dart';

abstract class TdModelSearchState extends Equatable {
  const TdModelSearchState();

  @override
  List<Object> get props => [];
}

class TdModelSearchInitialState extends TdModelSearchState {
  const TdModelSearchInitialState();
}

class TdModelSearching extends TdModelSearchState {
  const TdModelSearching();
}

class TdModelSearchResults<T extends TdModel> extends TdModelSearchState {
  const TdModelSearchResults(this.results);
  final Iterable<T> results;

  @override
  List<Object> get props => super.props..addAll([results]);

  @override
  String toString() => 'TdModelSearchResults results: $results';
}
