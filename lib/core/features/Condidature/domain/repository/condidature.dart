// domain/repository/condidature_repository.dart
import 'package:med/core/features/Condidature/domain/entity/condidature.dart';


abstract class CondidatureRepository {
  Future<CondidatureEntity?> getCondidatureByInternship(String internshipId);
  Future<void> addCondidature(CondidatureEntity condidature);
}
