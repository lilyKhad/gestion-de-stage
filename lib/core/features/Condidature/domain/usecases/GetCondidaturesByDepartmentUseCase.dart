import 'package:med/core/features/Condidature/domain/entity/condidature.dart';
import 'package:med/core/features/Condidature/domain/repository/condidature.dart';

class GetCondidaturesByDepartmentUseCase {
  final CondidatureRepository repository;

  GetCondidaturesByDepartmentUseCase(this.repository);

  Future<List<CondidatureEntity>> call(String department) async {
    return repository.getCondidaturesByDepartment(department);
  }
}
