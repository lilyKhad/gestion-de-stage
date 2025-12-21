import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med/features/Internship/data/model/internship.dart';

class InternshipRemoteDataSource {
  final FirebaseFirestore firestore;

  InternshipRemoteDataSource(this.firestore);

  // GET all internships
  Future<List<InternshipModel>> getInternships() async {
    final snapshot = await firestore.collection('internships').get();
    return snapshot.docs.map((doc) => _docToModel(doc)).toList();
  }

  // SEARCH internships by department or doctorName
  Future<List<InternshipModel>> searchInternships({String? department, String? doctorName}) async {
    Query collectionQuery = firestore.collection('internships');

    if (department != null && department.isNotEmpty) {
      collectionQuery = collectionQuery.where('department', isEqualTo: department);
    }

    if (doctorName != null && doctorName.isNotEmpty) {
      collectionQuery = collectionQuery.where('doctorName', isEqualTo: doctorName);
    }

    final snapshot = await collectionQuery.get();
    return snapshot.docs.map((doc) => _docToModel(doc)).toList();
  }

  // GET internships by department
  Future<List<InternshipModel>> getInternshipsByDepartment(String department) async {
    final query = await firestore
        .collection('internships')
        .where('department', isEqualTo: department.trim())
        .get();
    return query.docs.map((doc) => _docToModel(doc)).toList();
  }

  // GET internships by studentId (if you want to track student applications)
  Future<List<InternshipModel>> getInternshipsByStudent(String studentId) async {
    final query = await firestore
        .collection('internships')
        .where('studentId', isEqualTo: studentId.trim())
        .get();
    return query.docs.map((doc) => _docToModel(doc)).toList();
  }

  // ADD new internship
  Future<void> addInternship(InternshipModel internship) async {
    final data = internship.toMap();
    data['startDate'] = Timestamp.fromDate(internship.startDate);
    await firestore.collection('internships').doc(internship.id).set(data);
  }

  // UPDATE internship (including status)
  Future<void> updateInternship(InternshipModel internship) async {
    final data = internship.toMap();
    data['startDate'] = Timestamp.fromDate(internship.startDate);
    await firestore.collection('internships').doc(internship.id).update(data);
  }

  // DELETE internship
  Future<void> deleteInternship(String internshipId) async {
    await firestore.collection('internships').doc(internshipId).delete();
  }

  // PRIVATE: Convert Firestore doc → InternshipModel
  InternshipModel _docToModel(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return InternshipModel.fromMap({
      ...data,
      'id': doc.id, // make sure id is always correct
    });
  }
}