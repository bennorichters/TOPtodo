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
    if (query.isEmpty) {
      return const Text('No suggestions available!');
    }

    BlocProvider.of<BranchSearchBloc>(context)..add(BranchSearchQuery(query));
    return _stateDependendResult();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Text('No suggestions available!');
    }

    final Completer<Widget> completer = Completer<Widget>();
      _debouncer.run(() {
      completer.complete(_stateDependendResult());
    });

    return FutureBuilder<Widget>(
        future: completer.future,
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.connectionState == ConnectionState.done) {
            BlocProvider.of<BranchSearchBloc>(context)
              ..add(BranchSearchQuery(query));
            return snapshot.data;
          }

          throw StateError(
              'unexpected snapshot.connectionState: ${snapshot.connectionState}');
        });
  }

  BlocBuilder<BranchSearchBloc, BranchSearchState> _stateDependendResult() {
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
