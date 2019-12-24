import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Credentials extends Equatable {
  const Credentials({
    @required this.url,
    @required this.loginName,
    @required this.password,
  });

  final String url;
  final String loginName;
  final String password;

  bool isComplete() =>
      (url != null) && (loginName != null) && (password != null);

  @override
  List<Object> get props => <Object>[url, loginName, password];

  @override
  String toString() => 'Credentials: ['
      '$url, '
      '$loginName, '
      '${password == null ? "no" : "with"} password]';
}
