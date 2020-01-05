import 'package:equatable/equatable.dart';

class Credentials extends Equatable {
  const Credentials({
    this.url,
    this.loginName,
    this.password,
  });

  final String url;
  final String loginName;
  final String password;

  bool isComplete() =>
      (url != null) && (loginName != null) && (password != null);

  @override
  List<Object> get props => [url, loginName, password];

  @override
  String toString() => 'Credentials: ['
      '$url, '
      '$loginName, '
      '${password == null ? "no" : "with"} password]';
}
