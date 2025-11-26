// lib/domain/usecases/student/upload_document_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:med/core/errors/failures.dart';
import 'package:med/core/features/etudiant/domain/repositories/etudiant_repository.dart';
import 'package:med/core/usecase/usecase.dart';

class UploadDocumentParams {
  final String studentId;
  final String filePath;
  final String documentType;

  UploadDocumentParams({
    required this.studentId,
    required this.filePath,
    required this.documentType,
  });
}

class UploadDocumentUseCase implements UseCase<String, UploadDocumentParams> {
  final StudentRepository repository;

  UploadDocumentUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(UploadDocumentParams params) async {
    return await repository.uploadDocument(
      params.studentId,
      params.filePath,
      params.documentType,
    );
  }
}