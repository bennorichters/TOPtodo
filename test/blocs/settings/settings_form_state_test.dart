import 'package:test/test.dart';
import 'package:toptodo/blocs/settings/bloc.dart';
import 'package:toptodo_data/toptodo_data.dart';

void main() {
  group('settings form state', () {
    test('update branch clears caller', () async {
      final branchA = TdBranch(id: 'a', name: 'ba');
      final branchB = TdBranch(id: 'b', name: 'bb');
      final callerA =
          TdCaller(id: 'a', name: 'ca', avatar: '', branch: branchA);

      final state1 = SettingsFormState();
      final state2 = state1.update(
        updatedTdBranch: branchA,
        updatedTdCaller: callerA,
      );
      final state3 = state2.update(
        updatedTdBranch: branchB,
      );

      expect(state2.tdBranch, branchA);
      expect(state2.tdCaller, callerA);
      expect(state3.tdBranch, branchB);
      expect(state3.tdCaller, null);
    });

    test('toString', (){
      expect(SettingsFormState().toString().contains('branch'), isTrue);
    });
  });
}
