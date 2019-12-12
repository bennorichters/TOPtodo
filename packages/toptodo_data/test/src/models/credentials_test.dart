import 'package:test/test.dart';
import 'package:toptodo_data/toptodo_data.dart';

void main() {
  group('Credentials', () {
    test('basics', () {
      final Credentials c = Credentials(
        url: 'a',
        loginName: 'b',
        password: 'c',
      );
      expect(c.url, 'a');
      expect(c.loginName, 'b');
      expect(c.password, 'c');
    },);

    test('toString does not contain password', () {
      final Credentials c = Credentials(
        url: 'url',
        loginName: 'loginName',
        password: 'S3CrEt!',
      );

      expect(c.toString().contains('S3CrEt!'), isFalse);
    });
  });
}
