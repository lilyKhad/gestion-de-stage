// lib/domain/usecases/student/upload_document_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:med/core/errors/failures.dart';
import 'package:med/features/etudiant/domain/repositories/etudiant_repository.dart';

class UploadDocument {
  final StudentRepository repository;

  UploadDocument(this.repository);

  Future<Either<Failure, String>> call(String studentId, String filePath, String documentType) async {
    return await repository.uploadDocument(studentId, filePath, documentType);
  }
}
