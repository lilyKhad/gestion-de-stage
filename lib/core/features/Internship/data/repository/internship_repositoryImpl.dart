// data/repositories/internship_repository_impl.dart

import 'package:med/core/features/Internship/data/datasource/remotedata/remote_data_source.dart';
import 'package:med/core/features/Internship/domain/entity/internship.dart';
import 'package:med/core/features/Internship/domain/repository/internship_repo.dart';



class InternshipRepositoryImpl implements InternshipRepository {
  final InternshipRemoteDataSource remoteDataSource;

  InternshipRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Internship>> getInternships() async {
    return await remoteDataSource.getInternships();
  }
   @override
  Future<List<Internship>> searchInternships({String? department, String? doctorName}) async {
    return await remoteDataSource.searchInternships(
      department: department,
      doctorName: doctorName,
    );
  }
}
