// core/features/try/data/datasource/remotedata/remote_data_source.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med/core/features/Internship/data/model/internship.dart';
import 'package:med/core/features/Internship/domain/entity/internship.dart';



class InternshipRemoteDataSource {
  final FirebaseFirestore firestore;

  InternshipRemoteDataSource(this.firestore);

  Future<List<Internship>> getInternships() async {
    final snapshot = await firestore.collection('internships').get();
    return snapshot.docs.map((doc) => _docToModel(doc)).toList();
  }

  Future<List<Internship>> searchInternships({String? department, String? doctorName}) async {
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

  InternshipModel _docToModel(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return InternshipModel(
      id: doc.id,
      department: data['department'] ?? '',
      doctorName: data['doctorName'] ?? '',
      hospital: data['hospital'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      duree: data['duree'],
      notes: data['notes'],
    );
  }
}
