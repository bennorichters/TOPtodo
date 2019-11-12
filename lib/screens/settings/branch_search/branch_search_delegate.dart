import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptopdo/data/model/topdesk_elements.dart';

import 'bloc/bloc.dart';

class BranchSearchDelegate extends SearchDelegate<Branch> {
  BranchSearchDelegate() : _debouncer = _Debouncer(milliseconds: 500);
  final _Debouncer _debouncer;

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
    if (query.isNotEmpty) {
      BlocProvider.of<BranchSearchBloc>(context)..add(BranchSearchQuery(query));
    }

    return BlocBuilder<BranchSearchBloc, BranchSearchState>(
      builder: (BuildContext context, BranchSearchState state) {
        if (state is BranchSearchInitialState) {
          return const Text('Waiting for user input');
        }

        if (state is BranchSearchSearching) {
          return const CircularProgressIndicator();
        }

        if (state is BranchSearchResults) {
          return ListView(
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

  @override
  Widget buildSuggestions(BuildContext context) {
    print('BranchSearchDelegate.buildSuggestions query: $query');
    _debouncer.run(() => print('in debouncer query: $query'));

    return const Text('No suggestions available');
  }
}

class _Debouncer {
  _Debouncer({this.milliseconds});
  final int milliseconds;

  Timer _timer;

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
