import 'package:med/core/enums/statuts.dart';
import 'package:med/features/application/domain/entity/application.dart';

abstract class ApplicationRepository {
  Stream<List<ApplicationEntity>> getApplicationsByStudent(String studentId);
  Stream<List<ApplicationEntity>> getApplicationsByInternship(String internshipId);
  Future<void> addApplication(ApplicationEntity application);
  Future<void> updateApplicationStatus(String applicationId, InternshipStatus status);
  Future<List<ApplicationEntity>> getApplicationsByDoctor(String doctorId);
}
