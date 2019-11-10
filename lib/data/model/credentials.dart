import 'package:meta/meta.dart';

class Credentials {
  final String url;
  final String loginName;
  final String password;

  Credentials({
    @required this.url,
    @required this.loginName,
    @required this.password,
  });

  @override
  String toString() =>
      'Credentials: ['
      '$url, '
      '$loginName, '
      '${password == null ? "no" : "with"} password]';
}
