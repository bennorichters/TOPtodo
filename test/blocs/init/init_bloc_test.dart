import 'package:test/test.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:toptodo/blocs/init/bloc.dart';
import 'package:toptodo_data/toptodo_data.dart';

class MockCredentialsProvider extends Mock implements CredentialsProvider {}

class MockSettingsProvider extends Mock implements SettingsProvider {}

class MockTopdeskProvider extends Mock implements TopdeskProvider {}

void main() {
  group('init normal flow', () {
    final cp = MockCredentialsProvider();
    final sp = MockSettingsProvider();
    final tdp = MockTopdeskProvider();

    test('initial state', () async {
      final bloc = InitBloc(
        credentialsProvider: cp,
        settingsProvider: sp,
        topdeskProvider: tdp,
      );

      await emitsExactly(
        bloc,
        [
          LoadingInitData.empty(),
        ],
      );
    });
  });
}
