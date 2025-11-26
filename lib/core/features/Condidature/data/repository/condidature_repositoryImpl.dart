
import 'package:med/core/features/Condidature/data/datasource/remotedata.dart';
import 'package:med/core/features/Condidature/domain/entity/condidature.dart';
import 'package:med/core/features/Condidature/domain/repository/condidature.dart';


class CondidatureRepositoryImpl implements CondidatureRepository {
  final CondidatureRemoteDataSource remoteDataSource;

  CondidatureRepositoryImpl(this.remoteDataSource);

  @override
  Future<CondidatureEntity?> getCondidatureByInternship(String internshipId) async {
    return await remoteDataSource.getCondidatureByInternship(internshipId);
  }

  @override
  Future<void> addCondidature(CondidatureEntity condidature) async {
    await remoteDataSource.addCondidature(condidature);
  }
}
