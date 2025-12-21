import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med/core/enums/statuts.dart';


class InternshipModel {
  final String id;
  final String department;
  final String doctorId;
  final String doctorName;
  final String hospital;
  final DateTime startDate;
  final String duree;
  final String? notes;

  // Infos supplémentaires (anciennement condidature)
  final String niveauStage;
  final List<String> objectifs;
  final List<String> competences;
  final InternshipStatus status;

  InternshipModel({
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

  factory InternshipModel.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return InternshipModel.fromMap(map, doc.id);
  }

  factory InternshipModel.fromMap(Map<String, dynamic> map, [String? id]) {
    return InternshipModel(
      id: id ?? map['id'] ?? '',
      department: map['department'] ?? '',
      doctorId: map['doctorId'] ?? '',
      doctorName: map['doctorName'] ?? '',
      hospital: map['hospital'] ?? '',
      startDate: _parseDateTime(map['startDate']),
      duree: map['duree'] ?? '',
      notes: map['notes'],
      niveauStage: map['niveauStage'] ?? '',
      objectifs: List<String>.from(map['objectifs'] ?? []),
      competences: List<String>.from(map['competences'] ?? []),
      status: _parseStatus(map['status']),
    );
  }

  static DateTime _parseDateTime(dynamic date) {
    if (date is int) {
      return DateTime.fromMillisecondsSinceEpoch(date);
    } else if (date is Timestamp) {
      return date.toDate();
    } else if (date is String) {
      return DateTime.tryParse(date) ?? DateTime.now();
    } else {
      return DateTime.now();
    }
  }

  static InternshipStatus _parseStatus(dynamic status) {
    if (status is String) {
      return InternshipStatus.values.firstWhere(
        (e) => e.name == status,
        orElse: () => InternshipStatus.pending,
      );
    }
    return InternshipStatus.pending;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'department': department,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'hospital': hospital,
      'startDate': Timestamp.fromDate(startDate),
      'duree': duree,
      'notes': notes,
      'niveauStage': niveauStage,
      'objectifs': objectifs,
      'competences': competences,
      'status': status.name,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'department': department,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'hospital': hospital,
      'startDate': Timestamp.fromDate(startDate),
      'duree': duree,
      'notes': notes,
      'niveauStage': niveauStage,
      'objectifs': objectifs,
      'competences': competences,
      'status': status.name,
    };
  }

  // Supprimez cette méthode toEntity() si elle n'est pas nécessaire
  // Ou corrigez-la si vous en avez besoin
  InternshipModel copyWith({
    String? id,
    String? department,
    String? doctorId,
    String? doctorName,
    String? hospital,
    DateTime? startDate,
    String? duree,
    String? notes,
    String? niveauStage,
    List<String>? objectifs,
    List<String>? competences,
    InternshipStatus? status,
  }) {
    return InternshipModel(
      id: id ?? this.id,
      department: department ?? this.department,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      hospital: hospital ?? this.hospital,
      startDate: startDate ?? this.startDate,
      duree: duree ?? this.duree,
      notes: notes ?? this.notes,
      niveauStage: niveauStage ?? this.niveauStage,
      objectifs: objectifs ?? this.objectifs,
      competences: competences ?? this.competences,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'InternshipModel(id: $id, department: $department, doctorName: $doctorName, hospital: $hospital, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InternshipModel &&
        other.id == id &&
        other.department == department &&
        other.doctorId == doctorId &&
        other.doctorName == doctorName &&
        other.hospital == hospital &&
        other.startDate == startDate &&
        other.status == status;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      department,
      doctorId,
      doctorName,
      hospital,
      startDate,
      status,
    );
  }
}