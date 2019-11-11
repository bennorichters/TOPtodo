import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc.dart';

class BranchSearchDelegate extends SearchDelegate<String> {
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
    BlocProvider.of<BranchSearchBloc>(context)..add(BranchSearchQuery(query));

    return BlocBuilder<BranchSearchBloc, BranchSearchState>(
      builder: (BuildContext context, BranchSearchState state) {
        if (state is BranchSearchResults) {
          return ListView(
              children: state.results
                  .map((String result) => ListTile(
                        title: Text('---> $result'),
                        onTap: () {
                          print(result);
                        },
                      ))
                  .toList());
        } else {
          return const Text('no results');
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column();
  }
}
