import 'package:cloud_firestore/cloud_firestore.dart';

enum CondidatureStatus {
  added,
  pending,
  accepted,
  rejected,
  validated,
}

class CondidatureEntity {
  final String id;
  final String internshipId;
  final String department;
  final String doctorName;
  final String hospital;
  final String niveauStage;
  final String duree;
  final List<String> objectifs;
  final List<String> competences;
  final DateTime startDate;
  final String? imageUrl;
  final CondidatureStatus status;

  CondidatureEntity({
    required this.id,
    required this.internshipId,
    required this.department,
    required this.doctorName,
    required this.hospital,
    required this.niveauStage,
    required this.duree,
    required this.objectifs,
    required this.competences,
    required this.startDate,
    required this.imageUrl,
    required this.status,
  });

  factory CondidatureEntity.fromMap(Map<String, dynamic> map) {
    return CondidatureEntity(
      id: map['id'] ?? '',
      internshipId: map['internshipId'] ?? '',
      department: map['department'] ?? '',
      doctorName: map['doctorName'] ?? '',
      hospital: map['hospital'] ?? '',
      niveauStage: map['niveauStage'] ?? '',
      duree: map['duree'] ?? '',
      objectifs: List<String>.from(map['objectifs'] ?? []),
      competences: List<String>.from(map['competences'] ?? []),
      startDate: map['startDate'] is Timestamp
          ? (map['startDate'] as Timestamp).toDate()
          : DateTime.tryParse(map['startDate'] ?? '') ?? DateTime.now(),
      imageUrl: map['imageUrl'],
      
      // Convertir string → enum
      status: CondidatureStatus.values.firstWhere(
        (e) => e.toString() == 'CondidatureStatus.${map['status']}',
        orElse: () => CondidatureStatus.added,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'internshipId': internshipId,
      'department': department,
      'doctorName': doctorName,
      'hospital': hospital,
      'niveauStage': niveauStage,
      'duree': duree,
      'objectifs': objectifs,
      'competences': competences,
      'startDate': startDate,
      'imageUrl': imageUrl,

      //  enum → string
      'status': status.name,
    };
  }

  CondidatureEntity copyWith({
    String? id,
    String? internshipId,
    String? department,
    String? doctorName,
    String? hospital,
    DateTime? startDate,
    String? niveauStage,
    String? duree,
    List<String>? objectifs,
    List<String>? competences,
    String? imageUrl,
    CondidatureStatus? status,
  }) {
    return CondidatureEntity(
      id: id ?? this.id,
      internshipId: internshipId ?? this.internshipId,
      department: department ?? this.department,
      doctorName: doctorName ?? this.doctorName,
      hospital: hospital ?? this.hospital,
      startDate: startDate ?? this.startDate,
      niveauStage: niveauStage ?? this.niveauStage,
      duree: duree ?? this.duree,
      objectifs: objectifs ?? this.objectifs,
      competences: competences ?? this.competences,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
    );
  }
}
