import 'package:med/core/features/Condidature/domain/entity/condidature.dart';
import 'package:med/core/features/application/domain/entity/application.dart';

abstract class ApplicationRepository {
  Stream<List<ApplicationEntity>> getApplicationsByStudent(String studentId);
  Stream<List<ApplicationEntity>> getApplicationsByInternship(String internshipId);
  Future<void> addApplication(ApplicationEntity application);
  Future<void> updateApplicationStatus(String applicationId, CondidatureStatus status);
}
