/// Thrown when a TOPdesk models is requested that cannot be found
class TdModelNotFoundException implements Exception {
  const TdModelNotFoundException(this.message);
  final String message;

  @override
  String toString() => 'TdModelNotFoundException: $message';
}

/// Thrown when a request cannot be authorized by the TOPdesk server
class TdNotAuthorizedException implements Exception {
  const TdNotAuthorizedException(this.message);
  final String message;

  @override
  String toString() => 'TdNotAuthorizedException: $message';
}

/// Thrown when a request triggers an error response by the TOPdesk server
class TdBadRequestException implements Exception {
  const TdBadRequestException(this.message);
  final String message;

  @override
  String toString() => 'TdBadRequestException: $message';
}

/// Thrown when there is an error with contacting the TOPdesk server
class TdServerException implements Exception {
  const TdServerException(this.message);
  final String message;

  @override
  String toString() => 'TdServerException: $message';
}

/// Thrown when a request to the TOPdesk server times out
class TdTimeOutException implements Exception {
  const TdTimeOutException(this.message);
  final String message;

  @override
  String toString() => 'TdTimeOutException: $message';
}

/// Thrown when the TOPdesk server cannot be reached
class TdCannotConnect implements Exception {
  const TdCannotConnect(this.message);
  final String message;

  @override
  String toString() => 'TdCannotConnect: $message';
}