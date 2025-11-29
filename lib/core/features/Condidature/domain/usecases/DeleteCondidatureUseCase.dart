import 'package:med/core/features/Condidature/domain/repository/condidature.dart';

class DeleteCondidatureUseCase {
  final CondidatureRepository repository;

  DeleteCondidatureUseCase(this.repository);

  Future<void> call(String condidatureId) async {
    return repository.deleteCondidature(condidatureId);
  }
}
