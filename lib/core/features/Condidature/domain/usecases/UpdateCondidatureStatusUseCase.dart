import 'package:med/core/features/Condidature/domain/entity/condidature.dart';
import 'package:med/core/features/Condidature/domain/repository/condidature.dart';

class UpdateCondidatureStatusUseCase {
  final CondidatureRepository repository;

  UpdateCondidatureStatusUseCase(this.repository);

  Future<void> call(String condidatureId, CondidatureStatus status) async {
    return repository.updateStatus(condidatureId, status);
  }
}
