import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:toptodo_repository_providers_impl/src/credentials_provider.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  group('Credentials Provider', () {
    test('provide', () async {
    final mfss = MockFlutterSecureStorage();
      when(mfss.read(key: 'url')).thenAnswer((_) => Future.value('the url'));
      when(mfss.read(key: 'loginName'))
          .thenAnswer((_) => Future.value('the login name'));
      when(mfss.read(key: 'password'))
          .thenAnswer((_) => Future.value('the password'));

      final ssc = SecureStorageCredentials(
        storageProvider: () => mfss,
      );

      final credentials = await ssc.provide();
      expect(credentials.url, 'the url');
      expect(credentials.loginName, 'the login name');
      expect(credentials.password, 'the password');
    });
  });
}
