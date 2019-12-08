import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptodo/blocs/td_model_search/bloc.dart';
import 'package:toptodo_data/toptodo_data.dart';

class TdModelSearchDelegate extends SearchDelegate<TdModel> {
  TdModelSearchDelegate.allBranches()
      : _type = Branch,
        _linkedTo = null;

  TdModelSearchDelegate.personsForBranch({
    @required Branch branch,
  })  : _type = Person,
        _linkedTo = branch;

  TdModelSearchDelegate.allOperators()
      : _type = Operator,
        _linkedTo = null;

  final Type _type;
  final TdModel _linkedTo;

  static const Widget _emptyQueryText =
      Center(child: Text('Start typing in the bar at the top'));

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return _emptyQueryText;
    }

    BlocProvider.of<TdModelSearchBloc>(context)
      ..add(
        TdModelSearchFinishedQuery(
          searchInfo: SearchInfo(
            type: _type,
            linkedTo: _linkedTo,
            query: query,
          ),
        ),
      );
    return _stateDependendResult();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _emptyQueryText;
    }

    BlocProvider.of<TdModelSearchBloc>(context)
      ..add(
        TdModelSearchIncompleteQuery(
          searchInfo: SearchInfo(
            type: _type,
            linkedTo: _linkedTo,
            query: query,
          ),
        ),
      );
    return _stateDependendResult();
  }

  BlocBuilder<TdModelSearchBloc, TdModelSearchState> _stateDependendResult() {
    return BlocBuilder<TdModelSearchBloc, TdModelSearchState>(
      builder: (BuildContext context, TdModelSearchState state) {
        if (state is TdModelSearchInitialState) {
          return _emptyQueryText;
        }

        if (state is TdModelSearching) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TdModelSearchResults) {
          return state.results.isEmpty
              ? Center(child: Text("No results for '$query'"))
              : ListView(
                  children: state.results
                      .map(
                        (TdModel model) => ListTile(
                          leading: Icon(Icons.location_city),
                          title: Text(model.name),
                          onTap: () {
                            close(context, model);
                          },
                        ),
                      )
                      .toList(),
                );
        }

        throw StateError('unexpected state: $state');
      },
    );
  }
}
