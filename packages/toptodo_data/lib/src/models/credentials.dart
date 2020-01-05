import 'package:equatable/equatable.dart';

/// A 'pojo' for a user's credentials. 
/// 
/// A container for a URL, a login name and a password. All three elements can
/// be null. Instances of this class are immutable.
class Credentials extends Equatable {
  const Credentials({
    this.url,
    this.loginName,
    this.password,
  });

  /// URL 
  final String url;
  /// login name 
  final String loginName;
  /// password 
  final String password;

  /// Returns `true` if none of the fields are null, `false` otherwise.
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
