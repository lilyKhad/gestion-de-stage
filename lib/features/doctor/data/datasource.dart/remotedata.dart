import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med/features/application/domain/entity/application.dart';
import 'package:med/features/doctor/data/Models/doctor.dart';


abstract class DoctorRemoteDataSource {
  Future<DoctorModel?> getDoctor(String doctorId);
  Future<void> acceptApplication(ApplicationEntity application);
  Future<void> rejectApplication(ApplicationEntity application);
  Future<List<ApplicationEntity>> getApplications(String doctorId);

}

class DoctorRemoteDataSourceImpl implements DoctorRemoteDataSource {
  final FirebaseFirestore firestore;

  DoctorRemoteDataSourceImpl(this.firestore);

  @override
  Future<DoctorModel?> getDoctor(String doctorId) async {
    final doc = await firestore.collection('doctors').doc(doctorId).get();
    if (!doc.exists) return null;
    return DoctorModel.fromMap(doc.data()!, doc.id);
  }

  @override
  Future<void> acceptApplication(ApplicationEntity application) async {
    await firestore.collection('applications').doc(application.id).update({
      'status': 'accepted',
      'reviewedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> rejectApplication(ApplicationEntity application) async {
    await firestore.collection('applications').doc(application.id).update({
      'status': 'rejected',
      'reviewedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<List<ApplicationEntity>> getApplications(String doctorId) async {
    // 1. Fetch doctor internships
    final doctorDoc = await firestore.collection('doctors').doc(doctorId).get();
    if (!doctorDoc.exists) return [];
    final doctorData = doctorDoc.data()!;
    final List<String> internshipIds = List<String>.from(doctorData['internshipIds'] ?? []);

    if (internshipIds.isEmpty) return [];

    // 2. Fetch applications where internshipId is in doctor's internships
    final querySnapshot = await firestore
        .collection('applications')
        .where('internshipId', whereIn: internshipIds)
        .get();

    return querySnapshot.docs
        .map((doc) => ApplicationEntity.fromMap(doc.id, doc.data()))
        .toList();
  }
}
