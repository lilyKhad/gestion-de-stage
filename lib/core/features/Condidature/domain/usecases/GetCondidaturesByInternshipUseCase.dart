import 'package:med/core/features/Condidature/domain/entity/condidature.dart';
import 'package:med/core/features/Condidature/domain/repository/condidature.dart';

class GetCondidaturesByInternshipUseCase {
  final CondidatureRepository repository;

  GetCondidaturesByInternshipUseCase(this.repository);

  Future<List<CondidatureEntity>> call(String internshipId) async {
    return repository.getCondidaturesByInternship(internshipId);
  }
}
