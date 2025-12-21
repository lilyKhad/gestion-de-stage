import 'package:med/features/application/domain/entity/application.dart';
import 'package:med/features/doctor/entity/doctore.dart';
import 'package:med/features/doctor/entity/repository/doctor.dart';



/// Use case to fetch a doctor by ID
class GetDoctorUseCase {
  final DoctorRepository _repository;

  GetDoctorUseCase(this._repository);

  Future<DoctorEntity?> call(String doctorId) async {
    return await _repository.getDoctor(doctorId);
  }
}

/// Use case to accept an application
class AcceptApplicationUseCase {
  final DoctorRepository _repository;

  AcceptApplicationUseCase(this._repository);

  Future<void> call(ApplicationEntity application) async {
    await _repository.acceptApplication(application);
  }
}

/// Use case to reject an application
class RejectApplicationUseCase {
  final DoctorRepository _repository;

  RejectApplicationUseCase(this._repository);

  Future<void> call(ApplicationEntity application) async {
    await _repository.rejectApplication(application);
  }
}

/// Optional: Use case to get all applications assigned to a doctor
class GetDoctorApplicationsUseCase {
  final DoctorRepository _repository;

  GetDoctorApplicationsUseCase(this._repository);

  Future<List<ApplicationEntity>> call(String internshipId) async {
    return await _repository.getApplications(internshipId);
  }
}

