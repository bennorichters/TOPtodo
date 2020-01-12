import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:toptodo_data/toptodo_data.dart';

/// A provider for a [FlutterSecureStorage]
typedef StorageProvider = FlutterSecureStorage Function();

FlutterSecureStorage _defaultStorageProvider() => FlutterSecureStorage();

/// A [CredentialsProvider] that uses [FlutterSecureStorage].
class SecureStorageCredentials implements CredentialsProvider {
  /// Creates a [SecureStorageCredentials].
  /// 
  /// If the argument [storageProvider] is ommitted a default callback is used
  /// that provides a new instance of [FlutterSecureStorage].
  SecureStorageCredentials({this.storageProvider = _defaultStorageProvider});
  /// A callback for the [FlutterSecureStorage] that this object uses.
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
