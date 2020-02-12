import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:toptodo/blocs/init/bloc.dart';
import 'package:toptodo/screens/init/init_screen.dart';
import 'package:toptodo/screens/init/widgets/init_data_progress.dart';

import '../../helper.dart';

class MockInitBloc extends MockBloc<InitEvent, InitState>
    implements InitBloc {}

void main() {
  group('InitScreen', () {
    InitBloc bloc;

    void pumpScreen(
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        BlocProvider.value(
          value: bloc,
          child: TestableWidgetWithMediaQuery(
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
  });
}
