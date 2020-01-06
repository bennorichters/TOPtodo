import 'package:equatable/equatable.dart';

/// A 'pojo' for the credentials of a user.
///
/// A container for a URL, a login name and a password. 
/// 
/// Instances of this class are considered equal if and only if all matching 
/// fields of both instances are equal. All fields can be null. Instances of 
/// this class are immutable. 
class Credentials extends Equatable {
  /// Creates an instance of `Credentials`
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
  bool isComplete() => !props.contains(null);

  @override
  List<Object> get props => [url, loginName, password];

  @override
  String toString() => 'Credentials: ['
      '$url, '
      '$loginName, '
      '${password == null ? "no" : "with"} password]';
}
