import 'package:test/test.dart';
import 'package:toptodo_topdesk_provider_api/src/version.dart';

void main() {
  group('version', () {
    test('basics', () {
      expect(Version(3, 0, 1).major, 3);
      expect(Version(3, 0, 1).minor, 0);
      expect(Version(3, 0, 1).revision, 1);

      expect(Version.fromString('2020.1.21').major, 2020);
      expect(Version.fromString('2020.1.21').minor, 1);
      expect(Version.fromString('2020.1.21').revision, 21);
    });

    test('equals', () {
      expect(Version(3, 0, 1) == Version(3, 0, 1), isTrue);
      expect(Version(3, 0, 1) == Version(3, 0, 2), isFalse);
    });

    test('<', () {
      expect(Version(3, 0, 0) < Version(3, 0, 1), isTrue);
      expect(Version(3, 0, 1) < Version(3, 0, 1), isFalse);
      expect(Version(3, 0, 2) < Version(3, 0, 1), isFalse);

      expect(Version(2, 9, 9) < Version(3, 0, 1), isTrue);
      expect(Version(4, 0, 0) < Version(3, 0, 1), isFalse);
      expect(Version(3, 1, 0) < Version(3, 0, 1), isFalse);

      expect(Version(3, 1, 5) < Version(3, 2, 1), isTrue);
      expect(Version(3, 3, 5) < Version(3, 2, 1), isFalse);
    });

    test('>', () {
      expect(Version(3, 0, 0) > Version(3, 0, 1), isFalse);
      expect(Version(3, 0, 1) > Version(3, 0, 1), isFalse);
      expect(Version(3, 0, 2) > Version(3, 0, 1), isTrue);

      expect(Version(2, 9, 9) > Version(3, 0, 1), isFalse);
      expect(Version(4, 0, 0) > Version(3, 0, 1), isTrue);
      expect(Version(3, 1, 0) > Version(3, 0, 1), isTrue);

      expect(Version(3, 1, 5) > Version(3, 2, 1), isFalse);
      expect(Version(3, 3, 5) > Version(3, 2, 1), isTrue);
    });

    test('toString', () {
      expect(Version.fromString('2020.1.21').toString(), '2020.1.21');
    });

    group('errors', () {
      test('too many parts', () {
        expect(() => Version.fromString('1.2.3.4'), throwsArgumentError);
      });

      test('not enough many parts', () {
        expect(() => Version.fromString('1.2'), throwsArgumentError);
      });

      test('not integers', () {
        expect(() => Version.fromString('1.2.a'), throwsArgumentError);
      });
    });
  });
}
