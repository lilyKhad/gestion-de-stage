import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med/core/features/Condidature/domain/entity/condidature.dart';

class ApplicationEntity {
  final String id;
  final String studentId;
  final String internshipId;
  final CondidatureStatus status; // pending, accepted, rejected
  final DateTime appliedAt;

  ApplicationEntity({
    required this.id,
    required this.studentId,
    required this.internshipId,
    this.status = CondidatureStatus.pending,
    required this.appliedAt,
  });

  Map<String, dynamic> toMap() => {
        'studentId': studentId,
        'internshipId': internshipId,
        'status': status.name,
        'appliedAt': appliedAt,
      };

  factory ApplicationEntity.fromMap(String id, Map<String, dynamic> map) {
    return ApplicationEntity(
      id: id,
      studentId: map['studentId'],
      internshipId: map['internshipId'],
      status: CondidatureStatus.values.firstWhere(
          (e) => e.name == map['status'],
          orElse: () => CondidatureStatus.pending),
      appliedAt: (map['appliedAt'] as Timestamp).toDate(),
    );
  }
}
