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

    test('callers belonging to branch A starting with "s"', () async {
      final branchA = await tp.branch(id: 'a');
      final callers = await tp.callers(startsWith: 's', branch: branchA);

      bloc.add(
        TdModelSearchIncompleteQuery(
          searchInfo: SearchInfo<Caller>(
            linkedTo: branchA,
            query: 's',
          ),
        ),
      );

      await emitsExactly<TdModelSearchBloc, TdModelSearchState>(
        bloc,
        [
          TdModelSearchInitialState(),
          TdModelSearching(),
          TdModelSearchResults<Caller>(callers),
        ],
      );
    });

    test('operator starting with "a"', () async {
      final operators = await tp.incidentOperators(startsWith: 'a');

      bloc.add(
        const TdModelSearchIncompleteQuery(
          searchInfo: SearchInfo<IncidentOperator>(
            linkedTo: null,
            query: 'a',
          ),
        ),
      );

      await emitsExactly<TdModelSearchBloc, TdModelSearchState>(
        bloc,
        [
          TdModelSearchInitialState(),
          TdModelSearching(),
          TdModelSearchResults<IncidentOperator>(operators),
        ],
      );
    });

    test('operator finished query', () async {
      final operators = await tp.incidentOperators(startsWith: 'a');

      bloc.add(
        const TdModelSearchFinishedQuery(
          searchInfo: SearchInfo<IncidentOperator>(
            linkedTo: null,
            query: 'a',
          ),
        ),
      );

      await emitsExactly<TdModelSearchBloc, TdModelSearchState>(
        bloc,
        [
          TdModelSearchInitialState(),
          TdModelSearching(),
          TdModelSearchResults<IncidentOperator>(operators),
        ],
      );
    });

    group('reusing bloc', () {
      final bloc = TdModelSearchBloc(
        topdeskProvider: tp,
        debounceTime: Duration.zero,
      );

      test('first branch then callers', () async {
        final branches = await tp.branches(startsWith: 'br');
        final branchA = await tp.branch(id: 'a');
        final callers = await tp.callers(startsWith: 's', branch: branchA);

        final actual = <TdModelSearchState>[];
        final subscription = bloc.listen(actual.add);

        bloc.add(
          const TdModelSearchIncompleteQuery(
            searchInfo: SearchInfo<Branch>(
              linkedTo: null,
              query: 'br',
            ),
          ),
        );

        bloc.add(TdModelNewSearch());
        bloc.add(
          TdModelSearchIncompleteQuery(
            searchInfo: SearchInfo<Caller>(
              linkedTo: branchA,
              query: 's',
            ),
          ),
        );

        await bloc.close();
        await subscription.cancel();

        expect(actual, [
          TdModelSearchInitialState(),
          TdModelSearching(),
          TdModelSearchResults<Branch>(branches),
          TdModelSearchInitialState(),
          TdModelSearching(),
          TdModelSearchResults<Caller>(callers),
        ]);
      });
    });
  });
}
