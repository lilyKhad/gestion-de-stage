// domain/usecases/postuler_usecase.dart
import 'package:med/core/features/Condidature/domain/entity/condidature.dart';
import 'package:med/core/features/Condidature/domain/repository/condidature.dart';



class GetCondidatureUseCase {
  final CondidatureRepository repository;

  GetCondidatureUseCase(this.repository);

  Future<CondidatureEntity?> call(String internshipId) async {
    return await repository.getCondidatureByInternship(internshipId);
  }
}
