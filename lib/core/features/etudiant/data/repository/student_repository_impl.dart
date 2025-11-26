// lib/data/repositories/student_repository_impl.dart
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:med/core/errors/exceptions.dart';
import 'package:med/core/errors/failures.dart';
import 'package:med/core/features/etudiant/data/Models/student_model.dart';
import 'package:med/core/features/etudiant/data/data_source/student_firebase_datasource.dart';
import 'package:med/core/features/etudiant/domain/entities/etudiant.dart';
import 'package:med/core/features/etudiant/domain/repositories/etudiant_repository.dart';


class StudentRepositoryImpl implements StudentRepository {
  final StudentFirebaseDataSource dataSource;

  StudentRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, Student>> getStudent(String studentId) async {
    try {
      final student = await dataSource.getStudent(studentId);
      return Right(student);
    } on ServerException {
      return Left(ServerFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Student>> updateStudent(Student student) async {
    try {
      final studentModel = StudentModel.fromEntity(student);
      final updatedStudent = await dataSource.updateStudent(studentModel);
      return Right(updatedStudent);
    } on ServerException {
      return Left(ServerFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> uploadPhoto(String studentId, String filePath) async {
    try {
      final file = File(filePath);
      final photoUrl = await dataSource.uploadPhoto(studentId, file);
      return Right(photoUrl);
    } on ServerException {
      return Left(ServerFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> uploadDocument(String studentId, String filePath, String documentType) async {
    try {
      final file = File(filePath);
      final documentUrl = await dataSource.uploadDocument(studentId, file, documentType);
      return Right(documentUrl);
    } on ServerException {
      return Left(ServerFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteDocument(String studentId, String documentId) async {
    try {
      await dataSource.deleteDocument(studentId, documentId);
      return Right(null);
    } on ServerException {
      return Left(ServerFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getStudentDocuments(String studentId) async {
    try {
      final documents = await dataSource.getStudentDocuments(studentId);
      return Right(documents);
    } on ServerException {
      return Left(ServerFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}