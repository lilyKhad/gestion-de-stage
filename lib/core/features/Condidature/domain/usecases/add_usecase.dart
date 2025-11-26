// domain/usecases/add_condidature_usecase.dart
import 'package:med/core/features/Condidature/domain/entity/condidature.dart';
import 'package:med/core/features/Condidature/domain/repository/condidature.dart';



class AddCondidatureUseCase {
  final CondidatureRepository repository;

  AddCondidatureUseCase(this.repository);

  Future<void> call(CondidatureEntity condidature) async {
    await repository.addCondidature(condidature);
  }
}
