import 'package:med/core/features/Condidature/data/Models/condidature.dart';
import 'package:med/core/features/Condidature/data/datasource/remotedata.dart';
import 'package:med/core/features/Condidature/domain/entity/condidature.dart';
import 'package:med/core/features/Condidature/domain/repository/condidature.dart';

class CondidatureRepositoryImpl implements CondidatureRepository {
  final CondidatureRemoteDataSource remoteDataSource;

  CondidatureRepositoryImpl(this.remoteDataSource);

  // ---------------------------------------------------------
  // GET condidature by internshipId
  // ---------------------------------------------------------
  Future<CondidatureEntity?> getCondidatureByInternship(String internshipId) async {
    final model = await remoteDataSource.getCondidatureByInternship(internshipId);
    return model?.toEntity();
  }

  // ---------------------------------------------------------
  // GET all condidatures of a given internship
  // ---------------------------------------------------------
  @override
  Future<List<CondidatureEntity>> getCondidaturesByInternship(String internshipId) async {
    final models = await remoteDataSource.getCondidaturesByInternship(internshipId);
    return models.map((m) => m.toEntity()).toList();
  }

  // ---------------------------------------------------------
  // GET condidatures of a department (for doctor/chef service)
  // ---------------------------------------------------------
  @override
  Future<List<CondidatureEntity>> getCondidaturesByDepartment(String department) async {
    final models = await remoteDataSource.getCondidaturesByDepartment(department);
    return models.map((m) => m.toEntity()).toList();
  }

  // ---------------------------------------------------------
  // GET condidatures of a student
  // ---------------------------------------------------------
  @override
  Future<List<CondidatureEntity>> getCondidaturesByStudent(String studentId) async {
    final models = await remoteDataSource.getCondidaturesByStudent(studentId);
    return models.map((m) => m.toEntity()).toList();
  }

  // ---------------------------------------------------------
  // ADD condidature
  // ---------------------------------------------------------
  @override
  Future<void> addCondidature(CondidatureEntity condidature) async {
    final model = CondidatureModel.fromEntity(condidature);
    await remoteDataSource.addCondidature(model);
  }

  // ---------------------------------------------------------
  // DELETE condidature
  // ---------------------------------------------------------
  @override
  Future<void> deleteCondidature(String condidatureId) async {
    await remoteDataSource.deleteCondidature(condidatureId);
  }

  // ---------------------------------------------------------
  // UPDATE status (accepted / rejected / validated)
  // ---------------------------------------------------------
  @override
  Future<void> updateStatus(String condidatureId, CondidatureStatus status) async {
    await remoteDataSource.updateStatus(condidatureId, status);
  }
}
