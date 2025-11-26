

import 'package:med/core/features/Internship/domain/entity/internship.dart';
// repositories/internship_repository.dart
abstract class InternshipRepository {
  Future<List<Internship>> getInternships();
   // New method for search
  Future<List<Internship>> searchInternships({String? department, String? doctorName});
}