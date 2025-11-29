import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med/core/features/Condidature/domain/entity/condidature.dart';
import 'package:med/core/features/application/domain/entity/application.dart';

Future<void> applyToInternship({
  required String studentId,
  required String internshipId,
}) async {
  final docRef = FirebaseFirestore.instance.collection('applications').doc();

  final application = ApplicationEntity(
    id: docRef.id,
    studentId: studentId,
    internshipId: internshipId,
    status: CondidatureStatus.pending,
    appliedAt: DateTime.now(),
  );

  await docRef.set(application.toMap());
}
