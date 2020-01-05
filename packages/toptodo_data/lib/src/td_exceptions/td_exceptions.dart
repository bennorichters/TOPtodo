class TdModelNotFoundException implements Exception {
  const TdModelNotFoundException(this.message);
  final String message;

  @override
  String toString() => 'TdModelNotFoundException: $message';
}

class TdNotAuthorizedException implements Exception {
  const TdNotAuthorizedException(this.message);
  final String message;

  @override
  String toString() => 'TdNotAuthorizedException: $message';
}

class TdBadRequestException implements Exception {
  const TdBadRequestException(this.message);
  final String message;

  @override
  String toString() => 'TdBadRequestException: $message';
}

class TdServerException implements Exception {
  const TdServerException(this.message);
  final String message;

  @override
  String toString() => 'TdServerException: $message';
}

class TdTimeOutException implements Exception {
  const TdTimeOutException(this.message);
  final String message;

  @override
  String toString() => 'TdTimeOutException: $message';
}
