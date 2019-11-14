import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptopdo/models/topdesk_elements.dart';

import 'bloc/bloc.dart';

class BranchSearchDelegate extends SearchDelegate<Branch> {
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

    BlocProvider.of<BranchSearchBloc>(context)
      ..add(BranchSearchFinishedQuery(query));
    return _stateDependendResult();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _emptyQueryText;
    }

    BlocProvider.of<BranchSearchBloc>(context)
      ..add(BranchSearchIncompleteQuery(query));
    return _stateDependendResult();
  }

  BlocBuilder<BranchSearchBloc, BranchSearchState> _stateDependendResult() {
    return BlocBuilder<BranchSearchBloc, BranchSearchState>(
      builder: (BuildContext context, BranchSearchState state) {
        if (state is BranchSearchInitialState) {
          return _emptyQueryText;
        }

        if (state is BranchSearchSearching) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is BranchSearchResults) {
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
