import 'package:med/core/features/Condidature/domain/entity/condidature.dart';
import 'package:med/core/features/Condidature/domain/repository/condidature.dart';

class GetCondidaturesByStudentUseCase {
  final CondidatureRepository repository;

  GetCondidaturesByStudentUseCase(this.repository);

  Future<List<CondidatureEntity>> call(String studentId) async {
    return repository.getCondidaturesByStudent(studentId);
  }
}
