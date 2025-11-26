/// Base class for all exceptions.
abstract class Exception  {
  final String message;
  
  const Exception(this.message);
  
  @override
  String toString() => message;
}

/// Exception when there's a server error.
class ServerException extends Exception {
  const ServerException(String message, {String? mess}) : super(message);
}

/// Exception when there's a network error.
class NetworkException extends Exception {
  const NetworkException(String message) : super(message);
}

/// Exception when there's a cache error.
class CacheException extends Exception {
  const CacheException(String message) : super(message);
}

/// Exception when there's a validation error.
class ValidationException extends Exception {
  const ValidationException(String message) : super(message);
}

/// Exception when a resource is not found.
class NotFoundException extends Exception {
  const NotFoundException(String message) : super(message);
}

/// Exception when there's an authentication error.
class AuthenticationException extends Exception {
  const AuthenticationException(String message) : super(message);
}

/// Exception when there's an authorization error.
class AuthorizationException extends Exception {
  const AuthorizationException(String message) : super(message);
}

/// Exception when there's an unexpected error.
class UnexpectedException extends Exception {
  const UnexpectedException(String message) : super(message);
}