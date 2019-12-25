import 'package:test/test.dart';
import 'package:toptodo_data/toptodo_data.dart';

void main() {
  group('basics', () {
    test('toString', () {
      expect(Settings.empty().toString(), Settings.empty().toJson().toString());
    });
  });
}
