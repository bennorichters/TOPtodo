import 'package:meta/meta.dart';

class Credentials {
  Credentials({
    @required this.url,
    @required this.loginName,
    @required this.password,
  });

  final String url;
  final String loginName;
  final String password;

  @override
  String toString() =>
      'Credentials: ['
      '$url, '
      '$loginName, '
      '${password == null ? "no" : "with"} password]';
}
