import 'package:med/core/features/Condidature/domain/entity/condidature.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CondidatureModel extends CondidatureEntity {
  CondidatureModel({
    required String id,
    required String internshipId,
    
    required String department,
    required String doctorName,
    required String hospital,
    required String niveauStage,
    required String duree,
    required List<String> objectifs,
    required List<String> competences,
    required DateTime startDate,
    required String? imageUrl,
    required CondidatureStatus status,
  }) : super(
          id: id,
          internshipId: internshipId,
          department: department,
          doctorName: doctorName,
          hospital: hospital,
          niveauStage: niveauStage,
          duree: duree,
          objectifs: objectifs,
          competences: competences,
          startDate: startDate,
          imageUrl: imageUrl,
          status: status,
        );

  // Convert domain Entity → Model
  factory CondidatureModel.fromEntity(CondidatureEntity entity) {
    return CondidatureModel(
      id: entity.id,
      internshipId: entity.internshipId,
      department: entity.department,
      doctorName: entity.doctorName,
      hospital: entity.hospital,
      niveauStage: entity.niveauStage,
      duree: entity.duree,
      objectifs: List<String>.from(entity.objectifs),
      competences: List<String>.from(entity.competences),
      startDate: entity.startDate,
      imageUrl: entity.imageUrl,
      status: entity.status,
    );
  }

  // Convert Firebase Map → Model
  factory CondidatureModel.fromMap(Map<String, dynamic> map) {
  return CondidatureModel(
    id: map['id']?.toString() ?? '',
    internshipId: map['internshipId']?.toString() ?? '',
    department: map['department']?.toString() ?? '',
    doctorName: map['doctorName']?.toString() ?? '',
    hospital: map['hospital']?.toString() ?? '',
    startDate: map['startDate'] is int
        ? DateTime.fromMillisecondsSinceEpoch(map['startDate'])
        : map['startDate'] is Timestamp
            ? map['startDate'].toDate()
            : DateTime.now(), // fallback si manquant
    niveauStage: map['niveauStage']?.toString() ?? '',
    duree: map['duree']?.toString() ?? '',
    objectifs: List<String>.from(map['objectifs'] ?? []),
    competences: List<String>.from(map['competences'] ?? []),
    imageUrl: map['imageUrl']?.toString(),
    status: map['status'] != null
        ? CondidatureStatus.values.firstWhere(
            (e) => e.name == map['status'],
            orElse: () => CondidatureStatus.pending,
          )
        : CondidatureStatus.pending,
  );
}


  // Convert Model → Firebase Map
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
      'status': status.name, // enum → string
    };
  }

  @override
  CondidatureModel copyWith({
    String? id,
    String? internshipId,
    String? department,
    String? doctorName,
    String? hospital,
    String? niveauStage,
    String? duree,
    List<String>? objectifs,
    List<String>? competences,
    DateTime? startDate,
    String? imageUrl,
    CondidatureStatus? status,
  }) {
    return CondidatureModel(
      id: id ?? this.id,
      internshipId: internshipId ?? this.internshipId,
      department: department ?? this.department,
      doctorName: doctorName ?? this.doctorName,
      hospital: hospital ?? this.hospital,
      niveauStage: niveauStage ?? this.niveauStage,
      duree: duree ?? this.duree,
      objectifs: objectifs ?? List<String>.from(this.objectifs),
      competences: competences ?? List<String>.from(this.competences),
      startDate: startDate ?? this.startDate,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
    );
  }

  // Convert to Entity
  CondidatureEntity toEntity() {
    return CondidatureEntity(
      id: id,
      internshipId: internshipId,
      department: department,
      doctorName: doctorName,
      hospital: hospital,
      niveauStage: niveauStage,
      duree: duree,
      objectifs: objectifs,
      competences: competences,
      startDate: startDate,
      imageUrl: imageUrl,
      status: status,
    );
  }

  // Empty
  factory CondidatureModel.empty() {
    return CondidatureModel(
      id: '',
      internshipId: '',
      department: '',
      doctorName: '',
      hospital: '',
      niveauStage: '',
      duree: '',
      objectifs: [],
      competences: [],
      startDate: DateTime.now(),
      imageUrl: null,
      status: CondidatureStatus.pending,
    );
  }
}
