/// Base class for all exceptions.
abstract class Exception  {
  final String message;
  
  const Exception(this.message);
  
  @override
  String toString() => message;
}

/// Exception when there's a server error.
class ServerException extends Exception {
  const ServerException(super.message, {String? mess});
}

/// Exception when there's a network error.
class NetworkException extends Exception {
  const NetworkException(super.message);
}

/// Exception when there's a cache error.
class CacheException extends Exception {
  const CacheException(super.message);
}

/// Exception when there's a validation error.
class ValidationException extends Exception {
  const ValidationException(super.message);
}

/// Exception when a resource is not found.
class NotFoundException extends Exception {
  const NotFoundException(super.message);
}

/// Exception when there's an authentication error.
class AuthenticationException extends Exception {
  const AuthenticationException(super.message);
}

/// Exception when there's an authorization error.
class AuthorizationException extends Exception {
  const AuthorizationException(super.message);
}

/// Exception when there's an unexpected error.
class UnexpectedException extends Exception {
  const UnexpectedException(super.message);
}