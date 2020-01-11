import 'package:test/test.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:toptodo/blocs/td_model_search/bloc.dart';
import 'package:toptodo_data/toptodo_data.dart';
import 'package:toptodo_topdesk_provider_mock/toptodo_topdesk_provider_mock.dart';

void main() {
  group('search', () {
    final TopdeskProvider tp = FakeTopdeskProvider(latency: Duration.zero);
    var bloc;

    setUp(() async {
      bloc = TdModelSearchBloc(
        topdeskProvider: tp,
        debounceTime: Duration.zero,
      );
    });

    test('branches starting with "br"', () async {
      final branches = await tp.tdBranches(startsWith: 'br');

      bloc.add(
        const TdModelSearchIncompleteQuery<TdBranch>(
          linkedTo: null,
          query: 'br',
        ),
      );

      await emitsExactly<TdModelSearchBloc, TdModelSearchState>(
        bloc,
        [
          TdModelSearchInitialState(),
          TdModelSearching(),
          TdModelSearchResults<TdBranch>(branches),
        ],
      );
    });

    test('callers belonging to branch A starting with "s"', () async {
      final branchA = await tp.tdBranch(id: 'a');
      final callers = await tp.tdCallers(startsWith: 's', tdBranch: branchA);

      bloc.add(
        TdModelSearchIncompleteQuery<TdCaller>(
          linkedTo: branchA,
          query: 's',
        ),
      );

      await emitsExactly<TdModelSearchBloc, TdModelSearchState>(
        bloc,
        [
          TdModelSearchInitialState(),
          TdModelSearching(),
          TdModelSearchResults<TdCaller>(callers),
        ],
      );
    });

    test('operator starting with "a"', () async {
      final operators = await tp.tdOperators(startsWith: 'a');

      bloc.add(
        const TdModelSearchIncompleteQuery<TdOperator>(
          linkedTo: null,
          query: 'a',
        ),
      );

      await emitsExactly<TdModelSearchBloc, TdModelSearchState>(
        bloc,
        [
          TdModelSearchInitialState(),
          TdModelSearching(),
          TdModelSearchResults<TdOperator>(operators),
        ],
      );
    });

    test('operator finished query', () async {
      final operators = await tp.tdOperators(startsWith: 'a');

      bloc.add(
        const TdModelSearchFinishedQuery<TdOperator>(
          linkedTo: null,
          query: 'a',
        ),
      );

      await emitsExactly<TdModelSearchBloc, TdModelSearchState>(
        bloc,
        [
          TdModelSearchInitialState(),
          TdModelSearching(),
          TdModelSearchResults<TdOperator>(operators),
        ],
      );
    });

    group('reusing bloc', () {
      final bloc = TdModelSearchBloc(
        topdeskProvider: tp,
        debounceTime: Duration.zero,
      );

      test('first branch then callers', () async {
        final branches = await tp.tdBranches(startsWith: 'br');
        final branchA = await tp.tdBranch(id: 'a');
        final callers = await tp.tdCallers(startsWith: 's', tdBranch: branchA);

        final actual = <TdModelSearchState>[];
        final subscription = bloc.listen(actual.add);

        bloc.add(
          const TdModelSearchIncompleteQuery<TdBranch>(
            linkedTo: null,
            query: 'br',
          ),
        );

        bloc.add(TdModelNewSearch());
        bloc.add(
          TdModelSearchIncompleteQuery<TdCaller>(
            linkedTo: branchA,
            query: 's',
          ),
        );

        await bloc.close();
        await subscription.cancel();

        expect(actual, [
          TdModelSearchInitialState(),
          TdModelSearching(),
          TdModelSearchResults<TdBranch>(branches),
          TdModelSearchInitialState(),
          TdModelSearching(),
          TdModelSearchResults<TdCaller>(callers),
        ]);
      });
    });
  });
}
