// failures/internship_failure.dart
abstract class InternshipFailure implements Exception {
  final String message;

  InternshipFailure(this.message);
}

class GetInternshipsFailure extends InternshipFailure {
  GetInternshipsFailure(super.message);
}