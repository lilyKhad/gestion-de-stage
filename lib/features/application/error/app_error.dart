// core/error/application_error.dart
class ApplicationError implements Exception {
  final String message;
  final String? code;

  ApplicationError(this.message, {this.code});

  @override
  String toString() => 'ApplicationError: $message${code != null ? ' (Code: $code)' : ''}';
}