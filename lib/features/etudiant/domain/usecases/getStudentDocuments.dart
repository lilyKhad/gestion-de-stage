// lib/core/features/etudiant/domain/usecases/get_student_documents.dart
import 'package:dartz/dartz.dart';
import 'package:med/core/errors/failures.dart';
import 'package:med/features/etudiant/domain/repositories/etudiant_repository.dart';

class GetStudentDocuments {
  final StudentRepository repository;

  GetStudentDocuments(this.repository);

  Future<Either<Failure, List<String>>> call(String studentId) async {
    return await repository.getStudentDocuments(studentId);
  }
}
