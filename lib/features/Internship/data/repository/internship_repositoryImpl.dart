

import 'package:med/features/Internship/data/datasource/remotedata/remote_data_source.dart';
import 'package:med/features/Internship/data/model/internship.dart';
import 'package:med/features/Internship/data/model/mapper.dart';
import 'package:med/features/Internship/domain/entity/internship.dart';
import 'package:med/features/Internship/domain/repository/internship_repo.dart';

class InternshipRepositoryImpl implements InternshipRepository {
  final InternshipRemoteDataSource remoteDataSource;

  InternshipRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Internship>> getInternships() async {
    final models = await remoteDataSource.getInternships();
    return models.map((model) => InternshipMapper.toEntity(model)).toList();
  }

  @override
  Future<List<Internship>> searchInternships({String? department, String? doctorName}) async {
    final models = await remoteDataSource.searchInternships(
      department: department,
      doctorName: doctorName,
    );
    return models.map((model) => InternshipMapper.toEntity(model)).toList();
  }

  @override
  Future<List<Internship>> getInternshipsByDepartment(String department) async {
    final models = await remoteDataSource.getInternshipsByDepartment(department);
    return models.map((model) => InternshipMapper.toEntity(model)).toList();
  }

  @override
  Future<List<Internship>> getInternshipsByStudent(String studentId) async {
    final models = await remoteDataSource.getInternshipsByStudent(studentId);
    return models.map((model) => InternshipMapper.toEntity(model)).toList();
  }

  @override
  Future<void> addInternship(Internship internship) async {
    final model = InternshipMapper.toModel(internship);
    await remoteDataSource.addInternship(model as InternshipModel);
  }

  @override
  Future<void> updateInternship(Internship internship) async {
    final model = InternshipMapper.toModel(internship);
    await remoteDataSource.updateInternship(model as InternshipModel);
  }

  @override
  Future<void> deleteInternship(String internshipId) async {
    await remoteDataSource.deleteInternship(internshipId);
  }
}