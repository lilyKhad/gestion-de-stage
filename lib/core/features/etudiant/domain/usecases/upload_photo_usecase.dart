// lib/domain/usecases/student/upload_photo_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:med/core/errors/failures.dart';
import 'package:med/core/features/etudiant/domain/repositories/etudiant_repository.dart';
import 'package:med/core/usecase/usecase.dart';


class UploadPhotoParams {
  final String studentId;
  final String filePath;

  UploadPhotoParams({required this.studentId, required this.filePath});
}

class UploadPhotoUseCase implements UseCase<String, UploadPhotoParams> {
  final StudentRepository repository;

  UploadPhotoUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(UploadPhotoParams params) async {
    return await repository.uploadPhoto(params.studentId, params.filePath);
  }
}