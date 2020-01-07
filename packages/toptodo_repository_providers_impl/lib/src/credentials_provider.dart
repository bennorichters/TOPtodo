import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:toptodo_data/toptodo_data.dart';

typedef StorageProvider = FlutterSecureStorage Function();

FlutterSecureStorage _defaultStorageProvider() => FlutterSecureStorage();

class SecureStorageCredentials implements CredentialsProvider {
  SecureStorageCredentials({this.storageProvider = _defaultStorageProvider});
  final storageProvider;

  @override
  Future<Credentials> provide() async {
    final storage = storageProvider();
    final url = storage.read(key: 'url');
    final loginName = storage.read(key: 'loginName');
    final password = storage.read(key: 'password');

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
    final storage = storageProvider();
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

    return Future.wait(<Future<void>>[url, loginName, password]);
  }

  @override
  Future<void> delete() {
    final storage = storageProvider();
    return storage.deleteAll();
  }
}
