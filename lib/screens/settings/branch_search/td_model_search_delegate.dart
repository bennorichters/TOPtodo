import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptodo_data/toptodo_data.dart';

import 'bloc/bloc.dart';

class TdModelSearchDelegate extends SearchDelegate<Branch> {
  TdModelSearchDelegate.allOf({@required Type type})
      : _type = type,
        _linkedTo = null;

  TdModelSearchDelegate._linkedTo({
    @required Type type,
    @required Type linkedTo,
  })  : _type = type,
        _linkedTo = linkedTo;

  final Type _type;
  final Type _linkedTo;

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
                      .map((Branch branch) => ListTile(
                            leading: Icon(Icons.location_city),
                            title: Text(branch.name),
                            onTap: () {
                              close(context, branch);
                            },
                          ))
                      .toList());
        }

        throw StateError('unexpected state: $state');
      },
    );
  }
}
