import 'package:dartz/dartz.dart';
import 'package:med/core/errors/failure.dart';
import 'package:med/features/etudiant/domain/repositories/etudiant_repository.dart';

class UpdateProfilePicture {
  final StudentRepository repository;

  UpdateProfilePicture(this.repository);

  Future<Either<Failure, String>> call(String studentId, String photoUrl) async {
    final result = await repository.updateProfilePicture(studentId, photoUrl);

    // Transform Either<Failure, Student> → Either<Failure, String>
    return result.fold(
      (failure) => Left(failure as Failure),
      (student) => Right(student.photoUrl ?? ''), // Handle null photoUrl
    );
  }
}