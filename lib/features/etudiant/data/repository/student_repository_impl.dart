
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:med/core/errors/failures.dart';
import 'package:med/features/etudiant/data/data_source/student_firebase_datasource.dart';
import 'package:med/features/etudiant/domain/entities/etudiant.dart';
import 'package:med/features/etudiant/domain/repositories/etudiant_repository.dart';
import 'package:med/features/etudiant/domain/entities/documents.dart';

class StudentRepositoryImpl implements StudentRepository {
  final StudentRemoteDataSource remoteDataSource;

  StudentRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Student>> getStudent(String studentId) async {
    try {
      final student = await remoteDataSource.getStudent(studentId);
      if (student == null) return const Left(NotFoundFailure('Student not found'));
      return Right(student);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Student>> updateProfilePicture(String studentId, String photoUrl) async {
    try {
      await remoteDataSource.updateProfilePicture(studentId, photoUrl);
      final updated = await remoteDataSource.getStudent(studentId);
      if (updated == null) return const Left(NotFoundFailure('Student not found'));
      return Right(updated);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> uploadDocument(String studentId, String filePath, String documentType) async {
    try {
      await remoteDataSource.uploadDocument(studentId, filePath);
      return Right(filePath);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteDocument(String studentId, String documentUrl) async {
    try {
      await remoteDataSource.deleteDocument(studentId, documentUrl);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getStudentDocuments(String studentId) async {
    try {
      final docs = await remoteDataSource.getStudentDocuments(studentId);
      return Right(docs);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addDocumentToStudent(String studentId, StudentDocument newDoc) async {
    try {
      await remoteDataSource.addDocumentToStudent(studentId, newDoc);
      return const Right(null);
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        return const Left(NotFoundFailure('Student not found'));
      }
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}