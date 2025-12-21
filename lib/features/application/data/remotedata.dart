import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med/core/enums/statuts.dart';
import 'package:med/features/application/domain/entity/application.dart';

class ApplicationRemoteDataSource {
  final FirebaseFirestore _firestore;

  ApplicationRemoteDataSource(this._firestore);

   Stream<List<ApplicationEntity>> getApplicationsByStudent(String studentId) {
    return _firestore
        .collection('applications')
        .where('studentId', isEqualTo: studentId)
        // .orderBy('appliedAt', descending: true) // ← COMMENT THIS OUT TEMPORARILY
        .snapshots()
        .map((snapshot) {
          final applications = snapshot.docs
              .map((doc) => ApplicationEntity.fromMap(doc.id, doc.data()))
              .toList();
          
          // Sort manually locally as temporary solution
          applications.sort((a, b) => b.appliedAt.compareTo(a.appliedAt));
          return applications;
        });
  }

  Stream<List<ApplicationEntity>> getApplicationsByInternship(String internshipId) {
    return _firestore
        .collection('applications')
        .where('internshipId', isEqualTo: internshipId)
        .orderBy('appliedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ApplicationEntity.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<void> addApplication(ApplicationEntity application) async {
    await _firestore
        .collection('applications')
        .add(application.toMap());
  }

  Future<void> updateApplicationStatus(String applicationId, InternshipStatus status) async {
    await _firestore
        .collection('applications')
        .doc(applicationId)
        .update({'status': status.name});
  }
}