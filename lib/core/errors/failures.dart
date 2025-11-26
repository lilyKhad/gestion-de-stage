import 'package:equatable/equatable.dart';

/// Base class for all failures.
abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]) : super();
}

/// Failure when there's a server error.
class ServerFailure extends Failure {
  @override
  String toString() => 'Server Failure';
  
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

/// Failure when there's a network error.
class NetworkFailure extends Failure {
  @override
  String toString() => 'Network Failure';
  
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

/// Failure when there's a cache error.
class CacheFailure extends Failure {
  @override
  String toString() => 'Cache Failure';
  
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

/// Failure when there's a validation error.
class ValidationFailure extends Failure {
  final String message;
  
  const ValidationFailure(this.message);
  
  @override
  String toString() => 'Validation Failure: $message';
  
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

/// Failure when a resource is not found.
class NotFoundFailure extends Failure {
  final String message;
  
  const NotFoundFailure(this.message);
  
  @override
  String toString() => 'Not Found Failure: $message';
  
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

/// Failure when there's an authentication error.
class AuthenticationFailure extends Failure {
  final String message;
  
  const AuthenticationFailure(this.message);
  
  @override
  String toString() => 'Authentication Failure: $message';
  
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

/// Failure when there's an authorization error.
class AuthorizationFailure extends Failure {
  final String message;
  
  const AuthorizationFailure(this.message);
  
  @override
  String toString() => 'Authorization Failure: $message';
  
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

/// Failure when there's an unexpected error.
class UnexpectedFailure extends Failure {
  final String message;
  
  const UnexpectedFailure(this.message);
  
  @override
  String toString() => 'Unexpected Failure: $message';
  
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}