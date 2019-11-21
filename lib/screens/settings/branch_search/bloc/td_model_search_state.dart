import 'package:equatable/equatable.dart';
import 'package:toptodo_data/toptodo_data.dart';

abstract class TdModelSearchState extends Equatable {
  const TdModelSearchState();
}

class TdModelSearchInitialState extends TdModelSearchState {
  @override
  List<Object> get props => <Object> [];
}

 class TdModelSearching extends TdModelSearchState {
  @override
  List<Object> get props => <Object> [];
 }

class TdModelSearchResults extends TdModelSearchState {
  const TdModelSearchResults(this.results);
  final Iterable<TdModel> results;

  @override
  List<Object> get props => <Object> [results];
}
