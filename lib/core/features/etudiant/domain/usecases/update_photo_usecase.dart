// lib/domain/usecases/student/upload_photo_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:med/core/errors/failures.dart';
import 'package:med/core/features/etudiant/domain/repositories/etudiant_repository.dart';

class UpdateProfilePicture {
  final StudentRepository repository;

  UpdateProfilePicture(this.repository);

  Future<Either<Failure, String>> call(String studentId, String photoUrl) async {
    final result = await repository.updateProfilePicture(studentId, photoUrl);

    // Transform Either<Failure, Student> → Either<Failure, String>
    return result.fold(
      (failure) => Left(failure),
      (student) => Right(student.photoUrl), // Return the updated photoUrl
    );
  }
}

