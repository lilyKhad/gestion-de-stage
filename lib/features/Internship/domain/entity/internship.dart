

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med/core/enums/statuts.dart';

class Internship {
  final String id;
  final String department;
  final String doctorId;
  final String doctorName;
  final String hospital;
  final DateTime startDate;
  final String duree;
  final String? notes;
  final String niveauStage;
  final List<String> objectifs;
  final List<String> competences;
  final InternshipStatus status;

  Internship({
    required this.id,
    required this.department,
    required this.doctorId,
    required this.doctorName,
    required this.hospital,
    required this.startDate,
    required this.duree,
    this.notes,
    required this.niveauStage,
    required this.objectifs,
    required this.competences,
    required this.status,
  });

  // Convert to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'department': department,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'hospital': hospital,
      'startDate': startDate.millisecondsSinceEpoch,
      'duree': duree,
      'notes': notes,
      'niveauStage': niveauStage,
      'objectifs': objectifs,
      'competences': competences,
      'status': status.name,
    };
  }

  // Create from Firebase document
  factory Internship.fromMap(Map<String, dynamic> map) {
    return Internship(
      id: map['id'] ?? '',
      department: map['department'] ?? '',
      doctorId: map['doctorId'] ?? '',
      doctorName: map['doctorName'] ?? '',
      hospital: map['hospital'] ?? '',
      startDate: map['startDate'] is int
          ? DateTime.fromMillisecondsSinceEpoch(map['startDate'])
          : map['startDate'] is Timestamp
              ? map['startDate'].toDate()
              : DateTime.now(),
      duree: map['duree'] ?? '',
      notes: map['notes'],
      niveauStage: map['niveauStage'] ?? '',
      objectifs: List<String>.from(map['objectifs'] ?? []),
      competences: List<String>.from(map['competences'] ?? []),
      status: map['status'] != null
          ? InternshipStatus.values.firstWhere(
              (e) => e.name == map['status'],
              orElse: () => InternshipStatus.pending,
            )
          : InternshipStatus.pending,
    );
  }

  // Copy with method for easy updates
  Internship copyWith({
    String? id,
    String? department,
    String? doctorId,
    String? doctorName,
    String? hospital,
    DateTime? startDate,
    String? duree,
    String? notes,
    String? pictureUrl,
    String? niveauStage,
    List<String>? objectifs,
    List<String>? competences,
    InternshipStatus? status,
  }) {
    return Internship(
      id: id ?? this.id,
      department: department ?? this.department,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      hospital: hospital ?? this.hospital,
      startDate: startDate ?? this.startDate,
      duree: duree ?? this.duree,
      notes: notes ?? this.notes,
      niveauStage: niveauStage ?? this.niveauStage,
      objectifs: objectifs ?? List<String>.from(this.objectifs),
      competences: competences ?? List<String>.from(this.competences),
      status: status ?? this.status,
    );
  }
}
