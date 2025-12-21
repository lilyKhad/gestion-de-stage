import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:med/core/enums/statuts.dart';

class ApplicationEntity {
  final String id;
  final String studentId;
  final String internshipId;
  final InternshipStatus status; // pending, accepted, rejected
  final DateTime appliedAt;

  ApplicationEntity({
    required this.id,
    required this.studentId,
    required this.internshipId,
    this.status = InternshipStatus.pending,
    required this.appliedAt,
  });

  // Méthode copyWith ajoutée
  ApplicationEntity copyWith({
    String? id,
    String? studentId,
    String? internshipId,
    InternshipStatus? status,
    DateTime? appliedAt,
  }) {
    return ApplicationEntity(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      internshipId: internshipId ?? this.internshipId,
      status: status ?? this.status,
      appliedAt: appliedAt ?? this.appliedAt,
    );
  }

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
      status: InternshipStatus.values.firstWhere(
          (e) => e.name == map['status'],
          orElse: () => InternshipStatus.pending),
      appliedAt: (map['appliedAt'] as Timestamp).toDate(),
    );
  }
}

class DashboardRowData {
  final String id;
  final String studentName;
  final String studentId;
  final String hospitalName; 
  final DateTime startDate;
  final DateTime endDate; 
  final String status;

  DashboardRowData({
    required this.id,
    required this.studentName,
    required this.hospitalName,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.studentId,
  });
}