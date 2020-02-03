import 'package:test/test.dart';
import 'package:toptodo_data/toptodo_data.dart';

void main() {
  group('Credentials', () {
    test('basics', () {
      final c = Credentials(
        url: 'a',
        loginName: 'b',
        password: 'c',
      );
      expect(c.url, 'a');
      expect(c.loginName, 'b');
      expect(c.password, 'c');
    });

    test('empty', () {
      final c = Credentials();
      expect(c.url, isNull);
      expect(c.loginName, isNull);
      expect(c.password, isNull);
    });

    test('isComplete', () {
      expect(Credentials().isComplete, isFalse);
      expect(
          Credentials(
            url: 'url',
            loginName: null,
            password: null,
          ).isComplete,
          isFalse);
      expect(
          Credentials(
            url: 'url',
            loginName: 'a',
            password: 'b',
          ).isComplete,
          isTrue);
    });

    test('equals', () {
      final a = Credentials(
        url: 'url',
        loginName: 'a',
        password: 'b',
      );

      final b = Credentials(
        url: 'url',
        loginName: 'a',
        password: 'b',
      );

      final c = Credentials(
        url: 'url',
        loginName: 'a',
        password: 'c',
      );

      expect(a == b, isTrue);
      expect(a == c, isFalse);
    });

    test('toString does not contain password', () {
      final c = Credentials(
        url: 'url',
        loginName: 'loginName',
        password: 'S3CrEt!',
      );

      expect(c.toString().contains('S3CrEt!'), isFalse);
    });
  });
}
