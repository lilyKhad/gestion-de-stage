// domain/repository/condidature_repository.dart
import 'package:med/core/features/Condidature/domain/entity/condidature.dart';

abstract class CondidatureRepository {
  
  /// Étudiant → Voir ses candidatures
  Future<List<CondidatureEntity>> getCondidaturesByStudent(String studentId);

  /// Hôpital / Médecin → Voir les candidatures d’un stage
  Future<List<CondidatureEntity>> getCondidaturesByInternship(String internshipId);

  /// Chef de service → voir les candidatures d’un service hospitalier
  Future<List<CondidatureEntity>> getCondidaturesByDepartment(String department);

  /// Étudiant → Nouvelle candidature
  Future<void> addCondidature(CondidatureEntity condidature);

  /// Médecin / Établissement → Accepter / Rejeter / Valider
  Future<void> updateStatus(String condidatureId, CondidatureStatus status);

  /// Suppression si nécessaire
  Future<void> deleteCondidature(String condidatureId);
}
