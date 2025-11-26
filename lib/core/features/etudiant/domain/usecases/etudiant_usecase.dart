// lib/domain/usecases/student/update_student_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:med/core/errors/failures.dart';
import 'package:med/core/features/etudiant/domain/entities/etudiant.dart';
import 'package:med/core/features/etudiant/domain/repositories/etudiant_repository.dart';
import 'package:med/core/usecase/usecase.dart';


class UpdateStudentUseCase implements UseCase<Student, Student> {
  final StudentRepository repository;

  UpdateStudentUseCase(this.repository);

  @override
  Future<Either<Failure, Student>> call(Student student) async {
    return await repository.updateStudent(student);
  }
}