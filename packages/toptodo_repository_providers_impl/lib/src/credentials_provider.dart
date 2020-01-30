import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:toptodo_data/toptodo_data.dart';

const FlutterSecureStorage _defaultStorage = FlutterSecureStorage();

/// A [CredentialsProvider] that uses [FlutterSecureStorage].
class SecureStorageCredentials implements CredentialsProvider {
  /// Creates a [SecureStorageCredentials].
  ///
  /// If the argument [storage] is ommitted an instance of
  /// [FlutterSecureStorage] is used.
  SecureStorageCredentials({this.storage = _defaultStorage});

  /// The [FlutterSecureStorage] that this object uses.
  final storage;

  @override
  Future<Credentials> provide() async {
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
    return storage.deleteAll();
  }
}
