import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptopdo/data/model/topdesk_elements.dart';

import 'bloc/bloc.dart';

class BranchSearchDelegate extends SearchDelegate<Branch> {
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
                  .map((Branch branch) => ListTile(
                        leading: Icon(Icons.location_city),
                        title: Text(branch.name),
                        onTap: () {
                          close(context, branch);
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
