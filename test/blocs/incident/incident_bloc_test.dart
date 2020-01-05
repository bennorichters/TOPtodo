import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:toptodo_data/toptodo_data.dart';

import 'package:toptodo/blocs/incident/bloc.dart';

class MockSettingsProvider extends Mock implements SettingsProvider {}

class MockTopdeskProvider extends Mock implements TopdeskProvider {}

void main() {
  group('incident bloc', () {
    const settings = Settings(
      branchId: 'a',
      callerId: 'a',
      categoryId: 'a',
      subCategoryId: 'a',
      incidentDurationId: 'a',
      incidentOperatorId: 'a',
    );
    const currentOperator = IncidentOperator(
      id: 'a',
      name: 'a',
      avatar: 'a',
      firstLine: true,
      secondLine: true,
    );

    final sp = MockSettingsProvider();
    when(sp.provide()).thenAnswer((_) => Future.value(settings));

    final tdp = MockTopdeskProvider();
    when(tdp.currentIncidentOperator())
        .thenAnswer((_) => Future.value(currentOperator));
    when(tdp.createIncident(
      briefDescription: anyNamed('briefDescription'),
      request: anyNamed('request'),
      settings: anyNamed('settings'),
    )).thenAnswer((_) => Future.value('1'));

    blocTest<IncidentBloc, IncidentEvent, IncidentState>(
      'initial state',
      build: () => IncidentBloc(
        settingsProvider: sp,
        topdeskProvider: tdp,
      ),
      expect: [const InitialIncidentState()],
    );

    blocTest<IncidentBloc, IncidentEvent, IncidentState>(
      'IncidentShowForm emits OperatorLoaded',
      build: () => IncidentBloc(
        settingsProvider: sp,
        topdeskProvider: tdp,
      ),
      act: (bloc) async => {bloc.add(const IncidentShowForm())},
      expect: [
        const InitialIncidentState(),
        const OperatorLoaded(currentOperator: currentOperator),
      ],
    );

    blocTest<IncidentBloc, IncidentEvent, IncidentState>(
      'create incident normal flow',
      build: () => IncidentBloc(
        settingsProvider: sp,
        topdeskProvider: tdp,
      ),
      act: (bloc) async => {
        bloc.add(const IncidentSubmit(
          briefDescription: 'bd',
          request: '',
        ))
      },
      expect: [
        const InitialIncidentState(),
        const SubmittingIncident(currentOperator: currentOperator),
        const IncidentCreated(
          currentOperator: currentOperator,
          number: '1',
        ),
      ],
    );

    test('create incident TdException', () async {
      final timeOutTdProvider = MockTopdeskProvider();
      const exc = TdTimeOutException('error test');
      when(timeOutTdProvider.currentIncidentOperator())
          .thenAnswer((_) => Future.value(currentOperator));
      when(timeOutTdProvider.createIncident(
        briefDescription: anyNamed('briefDescription'),
        request: anyNamed('request'),
        settings: anyNamed('settings'),
      )).thenAnswer(
        (_) => Future.delayed(Duration.zero, () => throw exc),
      );

      final bloc = IncidentBloc(
        settingsProvider: sp,
        topdeskProvider: timeOutTdProvider,
      );

      final actual = <IncidentState>[];
      final subscription = bloc.listen(actual.add);

      bloc.add(const IncidentSubmit(
        briefDescription: 'bd',
        request: '',
      ));

      await bloc.close();
      await subscription.cancel();

      expect(
        actual,
        [
          const InitialIncidentState(),
          const SubmittingIncident(currentOperator: currentOperator),
          const IncidentCreationError(
            cause: exc,
            currentOperator: currentOperator,
          ),
        ],
      );
    });
  });
}
