
import 'package:dartz/dartz.dart';
import 'package:med/core/errors/failures.dart';
import 'package:med/features/etudiant/domain/entities/documents.dart';
import 'package:med/features/etudiant/domain/entities/etudiant.dart';

abstract class StudentRepository {
  Future<Either<Failure, Student>> getStudent(String studentId);
  Future<Either<Failure, Student>> updateProfilePicture(String studentId, String photoUrl);
  Future<Either<Failure, String>> uploadDocument(String studentId, String filePath, String documentType);
  Future<Either<Failure, void>> deleteDocument(String studentId, String documentId);
  Future<Either<Failure, List<String>>> getStudentDocuments(String studentId);
  Future<Either<Failure, void>> addDocumentToStudent(String studentId, StudentDocument newDoc); // Changed from void
}

