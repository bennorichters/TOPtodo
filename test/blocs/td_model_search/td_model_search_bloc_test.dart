import 'package:test/test.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:toptodo/blocs/td_model_search/bloc.dart';
import 'package:toptodo_data/toptodo_data.dart';
import 'package:toptodo_topdesk_provider_mock/toptodo_topdesk_provider_mock.dart';

void main() {
  group('search', () {
    test('find branches starting with "br"', () async {
      TopdeskProvider tp = FakeTopdeskProvider(latency: Duration.zero);
      final bloc = TdModelSearchBloc(
        topdeskProvider: tp,
        debounceTime: Duration.zero,
      );

      final branches = await tp.branches(startsWith: 'br');

      bloc.add(
        const TdModelSearchIncompleteQuery(
          searchInfo: SearchInfo<Branch>(
            linkedTo: null,
            query: 'br',
          ),
        ),
      );

      await emitsExactly<TdModelSearchBloc, TdModelSearchState>(
        bloc,
        [
          TdModelSearchInitialState(),
          TdModelSearching(),
          TdModelSearchResults<Branch>(branches),
        ],
      );
    });
  });
}
