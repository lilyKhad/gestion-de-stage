import 'package:dartz/dartz.dart';
import 'package:med/core/errors/failures.dart';
import 'package:med/features/etudiant/domain/entities/documents.dart';
import 'package:med/features/etudiant/domain/repositories/etudiant_repository.dart';

class AddDocumentToStudent {
  final StudentRepository repository;

  AddDocumentToStudent(this.repository);

  Future<Either<Failure, void>> call({
    required String studentId,
    required StudentDocument document,
  }) async {
    try {
      // Add document directly (repository handles upload logic if needed)
      await repository.addDocumentToStudent(studentId, document);
      return const Right(null);
    } on NotFoundFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}