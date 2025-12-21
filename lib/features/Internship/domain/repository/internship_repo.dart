import 'package:med/features/Internship/domain/entity/internship.dart';

abstract class InternshipRepository {
  Future<List<Internship>> getInternships();
  Future<List<Internship>> searchInternships({String? department, String? doctorName});
  Future<List<Internship>> getInternshipsByDepartment(String department);
  Future<List<Internship>> getInternshipsByStudent(String studentId);
  Future<void> addInternship(Internship internship);
  Future<void> updateInternship(Internship internship);
  Future<void> deleteInternship(String internshipId);
}