/// Base class for all exceptions related to API communication with a TOPdesk
/// server
abstract class TdException implements Exception {
  const TdException(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when the requested source cannot be found
class TdNotFoundException extends TdException {
  const TdNotFoundException(String message) : super(message);
}

/// Thrown when a request cannot be authorized by the TOPdesk server
class TdNotAuthorizedException extends TdException {
  const TdNotAuthorizedException(String message) : super(message);
}

/// Thrown when a request triggers an error response by the TOPdesk server
class TdBadRequestException extends TdException {
  const TdBadRequestException(String message) : super(message);
}

/// Thrown when there is an error with contacting the TOPdesk server
class TdServerException extends TdException {
  const TdServerException(String message) : super(message);
}

/// Thrown when a request to the TOPdesk server times out
class TdTimeOutException extends TdException {
  const TdTimeOutException(String message) : super(message);
}

/// Thrown when the TOPdesk server cannot be reached
class TdCannotConnect extends TdException {
  const TdCannotConnect(String message) : super(message);
}

/// Thrown when the version of the TOPdesk server is not supported
class TdVersionNotSupported extends TdException {
  const TdVersionNotSupported(String message) : super(message);
}
