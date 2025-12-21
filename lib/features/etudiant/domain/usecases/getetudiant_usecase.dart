// lib/domain/usecases/student/update_student_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:med/core/errors/failures.dart';
import 'package:med/features/etudiant/domain/entities/etudiant.dart';
import 'package:med/features/etudiant/domain/repositories/etudiant_repository.dart';

// lib/core/features/etudiant/domain/usecases/get_student.dart



class GetStudentUseCase {
  final StudentRepository repository;

  GetStudentUseCase(this.repository);

  Future<Either<Failure, Student>> call(String studentId) async {
    return await repository.getStudent(studentId);
  }
}
