import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptodo/blocs/td_model_search/bloc.dart';
import 'package:toptodo_data/toptodo_data.dart';

import 'package:toptodo/utils/colors.dart' show squash;

class TdModelSearchDelegate<T extends TdModel> extends SearchDelegate<T> {
  TdModelSearchDelegate.allBranches() : _linkedTo = null;

  TdModelSearchDelegate.callersForBranch({
    @required Branch branch,
  }) : _linkedTo = branch;

  TdModelSearchDelegate.allOperators() : _linkedTo = null;

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
        TdModelSearchFinishedQuery<T>(
          searchInfo: SearchInfo<T>(
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
        TdModelSearchIncompleteQuery<T>(
          searchInfo: SearchInfo<T>(
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
              : Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: ListView(
                    children: state.results
                        .map<Widget>(
                          (TdModel model) => ListTile(
                            leading: _Avatar(model),
                            title: Text(model.name),
                            onTap: () {
                              close(context, model);
                            },
                          ),
                        )
                        .toList(),
                  ),
                );
        }

        throw StateError('unexpected state: $state');
      },
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar(this.model);
  final TdModel model;

  @override
  Widget build(BuildContext context) {
    final TdModel item = model;
    if (item is Person) {
      return ClipOval(
        child: Image.memory(
          base64.decode(
            item.avatar,
          ),
        ),
      );
    }

    return CircleAvatar(
      backgroundColor: squash,
      child: Text(model.name.substring(0, 1).toUpperCase()),
    );
  }
}
