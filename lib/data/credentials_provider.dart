import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'model/credentials.dart';

abstract class CredentialsProvider {
  Future<Credentials> provide();
  Future<void> save(Credentials credentials);
}

class SecureStorageCredentials implements CredentialsProvider {
  @override
  Future<Credentials> provide() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final Future<String> url = storage.read(
      key: 'url',
    );
    final Future<String> loginName = storage.read(
      key: 'loginName',
    );
    final Future<String> password = storage.read(
      key: 'password',
    );

    return Future.wait(<Future<String>>[
      url,
      loginName,
      password,
    ]).then((List<String> data) {
      return Credentials(
        url: data[0],
        loginName: data[1],
        password: data[2],
      );
    });
  }

  @override
  Future<void> save(Credentials credentials) {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final Future<String> url = storage.write(
      key: 'url',
      value: credentials.url,
    );
    final Future<String> loginName = storage.write(
      key: 'loginName',
      value: credentials.loginName,
    );
    final Future<String> password = storage.write(
      key: 'password',
      value: credentials.password,
    );

    return Future.wait(<Future<String>>[
      url,
      loginName,
      password,
    ]);
  }
}
