import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:toptodo/blocs/init/bloc.dart';
import 'package:toptodo/screens/init/init_screen.dart';
import 'package:toptodo/screens/init/widgets/init_data_progress.dart';
import 'package:toptodo/widgets/error_dialog.dart';
import 'package:toptodo_data/toptodo_data.dart';

import '../../helper.dart';

class MockInitBloc extends MockBloc<InitEvent, InitState> implements InitBloc {}

void main() {
  group('InitScreen', () {
    final completeCredentials = Credentials(
      url: 'a',
      loginName: 'a',
      password: 'a',
    );

    final completeSettings = Settings(
      tdBranchId: 'a',
      tdCallerId: 'a',
      tdCategoryId: 'a',
      tdSubcategoryId: 'a',
      tdDurationId: 'a',
      tdOperatorId: 'a',
    );

    final currentOperator = TdOperator(
      id: 'a',
      name: 'a',
      avatar: 'a',
      firstLine: true,
      secondLine: true,
    );

    InitBloc bloc;

    void pumpScreen(
      WidgetTester tester, {
      Map<String, WidgetBuilder> routes,
    }) async {
      await tester.pumpWidget(
        BlocProvider.value(
          value: bloc,
          child: TestableWidgetWithMediaQuery(
            routes: routes,
            child: InitScreen(),
          ),
        ),
      );
    }

    setUp(() {
      bloc = MockInitBloc();
    });

    tearDown(() {
      bloc.close();
    });

    testWidgets('has InitDataProgress', (WidgetTester tester) async {
      when(bloc.state).thenReturn(InitData.empty());

      await pumpScreen(tester);

      expect(find.byType(InitDataProgress), findsOneWidget);
    });

    testWidgets('incomplete credentials navigates to login screen',
        (WidgetTester tester) async {
      final initialState = InitData.empty();
      when(bloc.state).thenReturn(initialState);
      whenListen(
        bloc,
        Stream.fromIterable(
          [
            initialState,
            InitData(credentials: Credentials()),
          ],
        ),
      );

      await pumpScreen(
        tester,
        routes: {'login': (_) => _TestScreen()},
      );
      await tester.pumpAndSettle();

      expect(find.byType(_TestScreen), findsOneWidget);
    });

    testWidgets(
      'complete credentials, incomplete settings, '
      'navigates to settings screen',
      (WidgetTester tester) async {
        final initialState = InitData.empty();
        when(bloc.state).thenReturn(initialState);
        whenListen(
          bloc,
          Stream.fromIterable(
            [
              initialState,
              InitData(credentials: completeCredentials, settings: Settings()),
            ],
          ),
        );

        await pumpScreen(
          tester,
          routes: {'settings': (_) => _TestScreen()},
        );
        await tester.pumpAndSettle();

        expect(find.byType(_TestScreen), findsOneWidget);
      },
    );

    testWidgets(
      'complete credentials, complete settings, '
      'navigates to incident screen',
      (WidgetTester tester) async {
        final initialState = InitData.empty();
        when(bloc.state).thenReturn(initialState);
        whenListen(
          bloc,
          Stream.fromIterable(
            [
              initialState,
              InitData(
                credentials: completeCredentials,
                settings: completeSettings,
                currentOperator: currentOperator,
              ),
            ],
          ),
        );

        await pumpScreen(
          tester,
          routes: {'incident': (_) => _TestScreen()},
        );
        await tester.pumpAndSettle();

        expect(find.byType(_TestScreen), findsOneWidget);
      },
    );

    testWidgets(
      'loading data failed, show error dialog',
      (WidgetTester tester) async {
        final initialState = InitData.empty();
        when(bloc.state).thenReturn(initialState);
        whenListen(
          bloc,
          Stream.fromIterable(
            [
              initialState,
              LoadingDataFailed('just testing', StackTrace.current),
            ],
          ),
        );

        await pumpScreen(tester);
        await tester.pumpAndSettle();

        expect(find.byType(ErrorDialog), findsOneWidget);
      },
    );
  });
}

class _TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container();
}