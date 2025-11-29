import 'package:med/core/features/Condidature/domain/entity/condidature.dart';
import 'package:med/core/features/application/data/remotedata.dart';
import 'package:med/core/features/application/domain/entity/application.dart';
import 'package:med/core/features/application/domain/repository/application_repository.dart';



class ApplicationRepositoryImpl implements ApplicationRepository {
  final ApplicationRemoteDataSource _remoteDataSource;

  ApplicationRepositoryImpl(this._remoteDataSource);

  @override
  Stream<List<ApplicationEntity>> getApplicationsByStudent(String studentId) {
    return _remoteDataSource.getApplicationsByStudent(studentId);
  }

  @override
  Stream<List<ApplicationEntity>> getApplicationsByInternship(String internshipId) {
    return _remoteDataSource.getApplicationsByInternship(internshipId);
  }

  @override
  Future<void> addApplication(ApplicationEntity application) {
    return _remoteDataSource.addApplication(application);
  }

  @override
  Future<void> updateApplicationStatus(String applicationId, CondidatureStatus status) {
    return _remoteDataSource.updateApplicationStatus(applicationId, status);
  }
}