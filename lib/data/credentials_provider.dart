import 'model/credentials.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class CredentialsProvider {
  Future<Credentials> provide();
  Future<void> save(Credentials credentials);
}

class SecureStorageCredentials implements CredentialsProvider {
  @override
  Future<Credentials> provide() async {
    final storage = FlutterSecureStorage();
    final url = storage.read(
      key: 'url',
    );
    final loginName = storage.read(
      key: 'loginName',
    );
    final password = storage.read(
      key: 'password',
    );

    return Future.wait([
      url,
      loginName,
      password,
    ]).then((data) {
      return Credentials(
        url: data[0],
        loginName: data[1],
        password: data[2],
      );
    });
  }

  @override
  Future<void> save(Credentials credentials) {
    final storage = FlutterSecureStorage();
    final url = storage.write(
      key: 'url',
      value: credentials.url,
    );
    final loginName = storage.write(
      key: 'loginName',
      value: credentials.loginName,
    );
    final password = storage.write(
      key: 'password',
      value: credentials.password,
    );

    return Future.wait([
      url,
      loginName,
      password,
    ]);
  }
}
