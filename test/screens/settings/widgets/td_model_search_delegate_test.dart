import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:toptodo/blocs/td_model_search/bloc.dart';
import 'package:toptodo/screens/settings/widgets/td_model_search_delegate.dart';
import 'package:toptodo_data/toptodo_data.dart';

import '../../../helper.dart';

typedef _DelegateBuilder = WidgetBuilder Function(SearchDelegate delegate);

typedef _TestMethod = Future<void> Function(
  WidgetTester tester,
  _DelegateBuilder delegateBuilder,
);

class MockTdModelSearchBloc
    extends MockBloc<TdModelSearchEvent, TdModelSearchState>
    implements TdModelSearchBloc {}

class _DelegateWrapper extends TdModelSearchDelegate {
  _DelegateWrapper.create() : super.allBranches();
  bool closeCalled;
  TdModel chosen;

  @override
  void close(BuildContext context, TdModel result) {
    closeCalled = true;
    chosen = result;
  }
}

class _UnknownState extends TdModelSearchState {}

const _startTyping = 'Start typing in the bar at the top';

void main() {
  group('TdModelSearchDelegate', () {
    testWidgets('buildActions', (WidgetTester tester) async {
      final delegate = TdModelSearchDelegate.allBranches();
      await tester.pumpWidget(TestableWidgetWithMediaQuery(
        child: Builder(
          builder: (context) => Column(
            children: delegate.buildActions(context),
          ),
        ),
      ));

      delegate.query = 'x';
      final clear = find.byIcon(Icons.clear);
      expect(clear, findsOneWidget);
      await tester.tap(clear);
      expect(delegate.query.isEmpty, isTrue);
    });

    testWidgets('buildLeading', (WidgetTester tester) async {
      final delegate = _DelegateWrapper.create();
      await tester.pumpWidget(TestableWidgetWithMediaQuery(
        child: Builder(
          builder: (context) => delegate.buildLeading(context),
        ),
      ));

      final back = find.byIcon(Icons.arrow_back);
      expect(back, findsOneWidget);
      await tester.tap(back);
      expect(delegate.closeCalled, isTrue);
    });

    testWidgets('buildResults empty query', (WidgetTester tester) async {
      final delegate = _DelegateWrapper.create();
      await tester.pumpWidget(TestableWidgetWithMediaQuery(
        child: Builder(
          builder: (context) => delegate.buildResults(context),
        ),
      ));

      expect(find.text(_startTyping), findsOneWidget);
    });

    testWidgets('callersForBranch', (WidgetTester tester) async {
      final delegate = TdModelSearchDelegate.callersForBranch(
        branch: TestConstants.branchA,
      );

      await tester.pumpWidget(TestableWidgetWithMediaQuery(
        child: Builder(
          builder: (context) => delegate.buildResults(context),
        ),
      ));

      expect(find.text(_startTyping), findsOneWidget);
    });

    testWidgets('allOperators', (WidgetTester tester) async {
      final delegate = TdModelSearchDelegate.allOperators();

      await tester.pumpWidget(TestableWidgetWithMediaQuery(
        child: Builder(
          builder: (context) => delegate.buildResults(context),
        ),
      ));

      expect(find.text(_startTyping), findsOneWidget);
    });

    group('with bloc', () {
      TdModelSearchBloc bloc;
      setUp(() {
        bloc = MockTdModelSearchBloc();
      });

      final buildResults = (SearchDelegate delegate) =>
          (BuildContext context) => delegate.buildResults(context);

      final buildSuggestions = (SearchDelegate delegate) =>
          (BuildContext context) => delegate.buildSuggestions(context);

      void pumpBuilder(
        WidgetTester tester,
        SearchDelegate delegate,
        _DelegateBuilder delegateBuilder,
      ) async {
        await tester.pumpWidget(BlocProvider.value(
          value: bloc,
          child: TestableWidgetWithMediaQuery(
            child: Builder(
              builder: delegateBuilder(delegate),
            ),
          ),
        ));
      }

      void resultsAndSuggestions(
        WidgetTester tester,
        _TestMethod call,
      ) async {
        await call(tester, buildResults);
        await call(tester, buildSuggestions);
      }

      testWidgets('with query buildResults adds SearchFinishedQuery to bloc',
          (WidgetTester tester) async {
        when(bloc.state).thenReturn(TdModelSearchInitialState());

        final delegate = _DelegateWrapper.create()..query = 'x';
        await pumpBuilder(tester, delegate, buildResults);

        verify(bloc.add(SearchFinishedQuery(
          linkedTo: null,
          query: 'x',
        ))).called(1);
      });

      testWidgets(
          'with query buildSuggestions adds SearchIncompleteQuery to bloc',
          (WidgetTester tester) async {
        when(bloc.state).thenReturn(TdModelSearchInitialState());

        final delegate = _DelegateWrapper.create()..query = 'x';
        await pumpBuilder(tester, delegate, buildSuggestions);

        verify(bloc.add(SearchIncompleteQuery(
          linkedTo: null,
          query: 'x',
        ))).called(1);
      });

      testWidgets('with query', (WidgetTester tester) async {
        resultsAndSuggestions(tester, (
          WidgetTester tester,
          _DelegateBuilder delegateBuilder,
        ) async {
          when(bloc.state).thenReturn(TdModelSearchInitialState());

          final delegate = _DelegateWrapper.create()..query = 'x';
          await pumpBuilder(tester, delegate, delegateBuilder);

          expect(
            find.text(_startTyping),
            findsOneWidget,
          );
        });
      });

      testWidgets('TdModelSearching', (WidgetTester tester) async {
        resultsAndSuggestions(tester, (
          WidgetTester tester,
          _DelegateBuilder delegateBuilder,
        ) async {
          when(bloc.state).thenReturn(TdModelSearching());

          final delegate = TdModelSearchDelegate.allBranches()..query = 'x';
          await pumpBuilder(tester, delegate, delegateBuilder);

          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        });
      });

      testWidgets('tdModelSearchResults no results',
          (WidgetTester tester) async {
        resultsAndSuggestions(tester, (
          WidgetTester tester,
          _DelegateBuilder delegateBuilder,
        ) async {
          when(bloc.state).thenReturn(TdModelSearchResults(<TdBranch>[]));

          final delegate = TdModelSearchDelegate.allBranches()..query = 'x';
          await pumpBuilder(tester, delegate, delegateBuilder);

          expect(find.text("No results for 'x'"), findsOneWidget);
        });
      });

      testWidgets('tdModelSearchResults with results',
          (WidgetTester tester) async {
        resultsAndSuggestions(tester, (
          WidgetTester tester,
          _DelegateBuilder delegateBuilder,
        ) async {
          when(bloc.state).thenReturn(TdModelSearchResults([
            TestConstants.branchA,
          ]));

          final delegate = _DelegateWrapper.create()..query = 'x';
          await pumpBuilder(tester, delegate, delegateBuilder);

          final result = find.text(TestConstants.branchA.name);
          expect(result, findsOneWidget);
          await tester.tap(result);
          expect(delegate.chosen, TestConstants.branchA);
        });
      });

      testWidgets('unknown state throws', (WidgetTester tester) async {
        resultsAndSuggestions(tester, (
          WidgetTester tester,
          _DelegateBuilder delegateBuilder,
        ) async {
          when(bloc.state).thenReturn(_UnknownState());

          final delegate = _DelegateWrapper.create()..query = 'x';
          await pumpBuilder(tester, delegate, delegateBuilder);
          expect(tester.takeException(), isInstanceOf<StateError>());
        });
      });
    });
  });
}
