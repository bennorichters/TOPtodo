import 'package:test/test.dart';
import 'package:toptodo/blocs/settings/bloc.dart';
import 'package:toptodo_data/toptodo_data.dart';

void main() {
  test('update branch clears caller', () async {
    final branchA = Branch(id: 'a', name: 'ba');
    final branchB = Branch(id: 'b', name: 'bb');
    final callerA = Caller(id: 'a', name: 'ca', avatar: '', branch: branchA);
    
    final state1 = SettingsFormState();
    final state2 = state1.update(
      updatedBranch: branchA,
      updatedCaller: callerA,
    );
    final state3 = state2.update(
      updatedBranch: branchB,
    );

    expect(state2.branch, branchA);
    expect(state2.caller, callerA);
    expect(state3.branch, branchB);
    expect(state3.caller, null);
  });
}
