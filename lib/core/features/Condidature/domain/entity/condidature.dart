import 'package:cloud_firestore/cloud_firestore.dart';

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
      'startDate': startDate, // Firestore handles DateTime automatically
      'imageUrl': imageUrl,
    };
  }

  // Copy with method for updates
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
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CondidatureEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'CondidatureEntity{id: $id, internshipId: $internshipId, department: $department, doctorName: $doctorName, hospital: $hospital, startDate: $startDate, niveauStage: $niveauStage, duree: $duree, objectifs: $objectifs, competences: $competences, imageUrl: $imageUrl}';
  }
}
