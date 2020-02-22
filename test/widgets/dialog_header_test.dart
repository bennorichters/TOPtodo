import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:toptodo/blocs/incident/bloc.dart';
import 'package:toptodo/screens/incident/incident_screen.dart';
import 'package:toptodo/widgets/menu_operator_button.dart';

import '../test_constants.dart' as test_constants;
import '../test_helper.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockIncidentBloc extends MockBloc<IncidentEvent, IncidentState>
    implements IncidentBloc {}

void main() {
  group('DialogHeader', () {
    testWidgets('open and close dialog from incident screen', (WidgetTester tester) async {
      final observer = MockNavigatorObserver();
      final IncidentBloc bloc = MockIncidentBloc();
      when(bloc.state).thenReturn(IncidentState(
        currentOperator: test_constants.currentOperator,
      ));

      await tester.pumpWidget(
        BlocProvider.value(
          value: bloc,
          child: TestableWidgetWithMediaQuery(
            navigatorObservers: [observer],
            child: IncidentScreen(),
          ),
        ),
      );
      await tester.tap(find.byType(MenuOperatorButton));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      verify(observer.didPop(any, any)).called(1);
    });
  });
}
