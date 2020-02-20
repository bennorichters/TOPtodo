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

class MockTdModelSearchBloc
    extends MockBloc<TdModelSearchEvent, TdModelSearchState>
    implements TdModelSearchBloc {}

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

      expect(find.text('Start typing in the bar at the top'), findsOneWidget);
    });

    group('with bloc', () {
      TdModelSearchBloc bloc;
      setUp(() {
        bloc = MockTdModelSearchBloc();
      });

      final buildResults = (SearchDelegate delegate) =>
          (BuildContext context) => delegate.buildResults(context);

      void pumpBuilder(WidgetTester tester, SearchDelegate delegate) async {
        await tester.pumpWidget(BlocProvider.value(
          value: bloc,
          child: TestableWidgetWithMediaQuery(
            child: Builder(
              builder: buildResults(delegate),
            ),
          ),
        ));
      }

      testWidgets('buildResults with query', (WidgetTester tester) async {
        when(bloc.state).thenReturn(TdModelSearchInitialState());

        final delegate = _DelegateWrapper.create()..query = 'x';
        await pumpBuilder(tester, delegate);

        verify(bloc.add(SearchFinishedQuery(
          linkedTo: null,
          query: 'x',
        ))).called(1);
        expect(find.text('Start typing in the bar at the top'), findsOneWidget);
      });

      testWidgets('TdModelSearching', (WidgetTester tester) async {
        when(bloc.state).thenReturn(TdModelSearching());

        final delegate = TdModelSearchDelegate.allBranches()..query = 'x';
        await pumpBuilder(tester, delegate);

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('TdModelSearchResults no results',
          (WidgetTester tester) async {
        when(bloc.state).thenReturn(TdModelSearchResults(<TdBranch>[]));

        final delegate = TdModelSearchDelegate.allBranches()..query = 'x';
        await pumpBuilder(tester, delegate);

        expect(find.text("No results for 'x'"), findsOneWidget);
      });

      testWidgets('TdModelSearchResults with results',
          (WidgetTester tester) async {
        when(bloc.state).thenReturn(TdModelSearchResults([
          TestConstants.branch,
        ]));

        final delegate = TdModelSearchDelegate.allBranches()..query = 'x';
        await pumpBuilder(tester, delegate);

        expect(find.text(TestConstants.branch.name), findsOneWidget);
      });
    });
  });
}

class _DelegateWrapper extends TdModelSearchDelegate {
  _DelegateWrapper.create() : super.allBranches();
  bool closeCalled = false;

  @override
  void close(BuildContext context, TdModel result) => closeCalled = true;
}
