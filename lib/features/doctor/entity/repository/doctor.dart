import 'package:med/features/application/domain/entity/application.dart';
import 'package:med/features/doctor/entity/doctore.dart';



abstract class DoctorRepository {
  Future<DoctorEntity?> getDoctor(String doctorId);
  Future<void> acceptApplication(ApplicationEntity application);
  Future<void> rejectApplication(ApplicationEntity application);
  Future<List<ApplicationEntity>> getApplications(String doctorId);
}
