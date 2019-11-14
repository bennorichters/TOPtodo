import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:toptopdo/models/credentials.dart';
import 'package:toptopdo/repository_providers_api/repository_providers_api.dart';

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
    final Future<void> url = storage.write(
      key: 'url',
      value: credentials.url,
    );
    final Future<void> loginName = storage.write(
      key: 'loginName',
      value: credentials.loginName,
    );
    final Future<void> password = storage.write(
      key: 'password',
      value: credentials.password,
    );

    return Future.wait(<Future<void>>[
      url,
      loginName,
      password,
    ]);
  }
}
