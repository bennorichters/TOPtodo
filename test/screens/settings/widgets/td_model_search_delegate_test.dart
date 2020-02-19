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

    testWidgets('buildResults empty query', (WidgetTester tester) async {
      TdModelSearchBloc bloc = MockTdModelSearchBloc();
      when(bloc.state).thenReturn(TdModelSearchInitialState());

      final delegate = _DelegateWrapper.create();
      delegate.query = 'x';

      await tester.pumpWidget(BlocProvider.value(
        value: bloc,
        child: TestableWidgetWithMediaQuery(
          child: Builder(
            builder: (context) => delegate.buildResults(context),
          ),
        ),
      ));

      verify(bloc.add(SearchFinishedQuery(
        linkedTo: null,
        query: 'x',
      ))).called(1);
      expect(find.text('Start typing in the bar at the top'), findsOneWidget);
    });
  });
}

class _DelegateWrapper extends TdModelSearchDelegate {
  _DelegateWrapper.create() : super.allBranches();
  bool closeCalled = false;

  @override
  void close(BuildContext context, TdModel result) => closeCalled = true;
}
