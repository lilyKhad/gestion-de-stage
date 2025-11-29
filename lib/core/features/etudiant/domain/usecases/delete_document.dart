// lib/core/features/etudiant/domain/usecases/delete_document.dart
import 'package:dartz/dartz.dart';
import 'package:med/core/errors/failures.dart';
import 'package:med/core/features/etudiant/domain/repositories/etudiant_repository.dart';

class DeleteDocument {
  final StudentRepository repository;

  DeleteDocument(this.repository);

  Future<Either<Failure, void>> call(String studentId, String documentId) async {
    return await repository.deleteDocument(studentId, documentId);
  }
}
