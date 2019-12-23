import 'package:equatable/equatable.dart';
import 'package:toptodo_data/toptodo_data.dart';

abstract class TdModelSearchState extends Equatable {
  const TdModelSearchState();
}

class TdModelSearchInitialState extends TdModelSearchState {
  @override
  List<Object> get props => [];
}

 class TdModelSearching extends TdModelSearchState {
  @override
  List<Object> get props => [];
 }

class TdModelSearchResults<T extends TdModel> extends TdModelSearchState {
  const TdModelSearchResults(this.results);
  final Iterable<T> results;

  @override
  List<Object> get props => [results];
}
