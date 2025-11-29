import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med/core/features/Condidature/data/Models/condidature.dart';
import 'package:med/core/features/Condidature/domain/entity/condidature.dart';

class CondidatureRemoteDataSource {
  final FirebaseFirestore firestore;

  CondidatureRemoteDataSource(this.firestore);

  // GET single condidature by internshipId
  Future<CondidatureModel?> getCondidatureByInternship(String internshipId) async {
    try {
      final query = await firestore
          .collection('Condidature')
          .where('internshipId', isEqualTo: internshipId.trim())
          .limit(1)
          .get();

      if (query.docs.isEmpty) return null;

      final data = _normalizeMap(query.docs.first.data());
      return CondidatureModel.fromMap(data);
    } catch (e) {
      print('❌ Error fetching condidature: $e');
      return null;
    }
  }

  // GET all condidatures by internship
  Future<List<CondidatureModel>> getCondidaturesByInternship(String internshipId) async {
    try {
      final query = await firestore
          .collection('Condidature')
          .where('internshipId', isEqualTo: internshipId.trim())
          .get();

      return query.docs
          .map((doc) => CondidatureModel.fromMap(_normalizeMap(doc.data())))
          .toList();
    } catch (e) {
      print('❌ Error fetching condidatures by internship: $e');
      return [];
    }
  }

  // GET condidatures by department
  Future<List<CondidatureModel>> getCondidaturesByDepartment(String department) async {
    try {
      final query = await firestore
          .collection('Condidature')
          .where('department', isEqualTo: department.trim())
          .get();

      return query.docs
          .map((doc) => CondidatureModel.fromMap(_normalizeMap(doc.data())))
          .toList();
    } catch (e) {
      print('❌ Error fetching condidatures by department: $e');
      return [];
    }
  }

  // GET condidatures by studentId
  Future<List<CondidatureModel>> getCondidaturesByStudent(String studentId) async {
    try {
      final query = await firestore
          .collection('Condidature')
          .where('studentId', isEqualTo: studentId.trim())
          .get();

      return query.docs
          .map((doc) => CondidatureModel.fromMap(_normalizeMap(doc.data())))
          .toList();
    } catch (e) {
      print('❌ Error fetching condidatures by student: $e');
      return [];
    }
  }

  // Add condidature
  Future<void> addCondidature(CondidatureModel condidature) async {
    try {
      final data = condidature.toMap();
      data['startDate'] = Timestamp.fromDate(condidature.startDate);
      await firestore.collection('Condidature').doc(condidature.id).set(data);
    } catch (e) {
      print('❌ Error adding condidature: $e');
      rethrow;
    }
  }

  // Update status
  Future<void> updateStatus(String condidatureId, CondidatureStatus status) async {
    try {
      await firestore.collection('Condidature').doc(condidatureId).update({'status': status.name});
    } catch (e) {
      print('❌ Error updating status: $e');
      rethrow;
    }
  }

  // Delete condidature
  Future<void> deleteCondidature(String condidatureId) async {
    try {
      await firestore.collection('Condidature').doc(condidatureId).delete();
    } catch (e) {
      print('❌ Error deleting condidature: $e');
      rethrow;
    }
  }

  // Normalize map
  Map<String, dynamic> _normalizeMap(Map<String, dynamic> data) {
    final normalized = Map<String, dynamic>.from(data);
    final startDate = data['startDate'];
    if (startDate is Timestamp) {
      normalized['startDate'] = startDate.millisecondsSinceEpoch;
    }
    return normalized;
  }
}
