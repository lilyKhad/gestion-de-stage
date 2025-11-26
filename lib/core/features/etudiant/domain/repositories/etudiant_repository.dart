// lib/domain/repositories/student_repository.dart
import 'package:dartz/dartz.dart';
import 'package:med/core/errors/failures.dart';
import 'package:med/core/features/etudiant/domain/entities/etudiant.dart';


abstract class StudentRepository {
  Future<Either<Failure, Student>> getStudent(String studentId);
  Future<Either<Failure, Student>> updateStudent(Student student);
  Future<Either<Failure, String>> uploadPhoto(String studentId, String filePath);
  Future<Either<Failure, String>> uploadDocument(String studentId, String filePath, String documentType);
  Future<Either<Failure, void>> deleteDocument(String studentId, String documentId);
  Future<Either<Failure, List<String>>> getStudentDocuments(String studentId);
}