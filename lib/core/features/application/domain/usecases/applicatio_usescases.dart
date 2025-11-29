import 'package:med/core/features/Condidature/domain/entity/condidature.dart';
import 'package:med/core/features/application/domain/entity/application.dart';
import 'package:med/core/features/application/domain/repository/application_repository.dart';

class AddApplicationUseCase {
  final ApplicationRepository _repository;

  AddApplicationUseCase(this._repository);

  Future<void> call(ApplicationEntity application) async {
    return await _repository.addApplication(application);
  }
}

class GetApplicationsByStudentUseCase {
  final ApplicationRepository _repository;

  GetApplicationsByStudentUseCase(this._repository);

  Stream<List<ApplicationEntity>> call(String studentId) {
    return _repository.getApplicationsByStudent(studentId);
  }
}

class GetApplicationsByInternshipUseCase {
  final ApplicationRepository _repository;

  GetApplicationsByInternshipUseCase(this._repository);

  Stream<List<ApplicationEntity>> call(String internshipId) {
    return _repository.getApplicationsByInternship(internshipId);
  }
}

class UpdateApplicationStatusUseCase {
  final ApplicationRepository _repository;

  UpdateApplicationStatusUseCase(this._repository);

  Future<void> call(String applicationId, CondidatureStatus status) async {
    return await _repository.updateApplicationStatus(applicationId, status);
  }
}