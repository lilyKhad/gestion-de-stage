// data/models/condidature_model.dart
import 'package:med/core/features/Condidature/domain/entity/condidature.dart';



class CondidatureModel extends CondidatureEntity {
  CondidatureModel({
    required String id,
    required String department,
    required String doctorName,
    required String hospital,
    required DateTime startDate,
    required String niveauStage,
    required String duree,
    required List<String> objectifs,
    required List<String> competences,
    required String? imageUrl,
    required String internshipId,
  }) : super(
          id: id,
          department: department,
          doctorName: doctorName,
          hospital: hospital,
          startDate: startDate,
          niveauStage: niveauStage,
          duree: duree,
          objectifs: objectifs,
          competences: competences,
          imageUrl: imageUrl,
          internshipId: internshipId,
        );

  // Convert from Entity to Model
  factory CondidatureModel.fromEntity(CondidatureEntity entity) {
    return CondidatureModel(
      id: entity.id,
      department: entity.department,
      doctorName: entity.doctorName,
      hospital: entity.hospital,
      startDate: entity.startDate,
      niveauStage: entity.niveauStage,
      duree: entity.duree,
      objectifs: List<String>.from(entity.objectifs),
      competences: List<String>.from(entity.competences),
      imageUrl: entity.imageUrl, 
      internshipId: entity.internshipId,
    );
  }

  // Convert from Map (Firebase) to Model
  factory CondidatureModel.fromMap(Map<String, dynamic> map) {
    return CondidatureModel(
      id: map['id'] ?? '',
      department: map['department'] ?? '',
      doctorName: map['doctorName'] ?? '',
      hospital: map['hospital'] ?? '',
      startDate: DateTime.fromMillisecondsSinceEpoch(
        map['startDate'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      niveauStage: map['niveauStage'] ?? '',
      duree: map['duree'] ?? '',
      objectifs: List<String>.from(map['objectifs'] ?? []),
      competences: List<String>.from(map['competences'] ?? []),
      imageUrl: map['imageUrl'], internshipId: map['internshipId']?? '',
    );
  }

  // Convert Model to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'department': department,
      'doctorName': doctorName,
      'hospital': hospital,
      'startDate': startDate.millisecondsSinceEpoch,
      'niveauStage': niveauStage,
      'duree': duree,
      'objectifs': objectifs,
      'competences': competences,
      'imageUrl': imageUrl,
      'internshipId':internshipId,
    };
  }

  // Copy with method
  @override
  CondidatureModel copyWith({
    String? id,
    String? department,
    String? doctorName,
    String? hospital,
    DateTime? startDate,
    String? niveauStage,
    String? duree,
    List<String>? objectifs,
    List<String>? competences,
    String? imageUrl,
    String? internshipId,
  }) {
    return CondidatureModel(
      id: id ?? this.id,
      department: department ?? this.department,
      doctorName: doctorName ?? this.doctorName,
      hospital: hospital ?? this.hospital,
      startDate: startDate ?? this.startDate,
      niveauStage: niveauStage ?? this.niveauStage,
      duree: duree ?? this.duree,
      objectifs: objectifs ?? List<String>.from(this.objectifs),
      competences: competences ?? List<String>.from(this.competences),
      imageUrl: imageUrl ?? this.imageUrl,
      internshipId: internshipId ?? this.internshipId,
    );
  }

  // Convert to Entity
  CondidatureEntity toEntity() {
    return CondidatureEntity(
      id: id,
      department: department,
      doctorName: doctorName,
      hospital: hospital,
      startDate: startDate,
      niveauStage: niveauStage,
      duree: duree,
      objectifs: List<String>.from(objectifs),
      competences: List<String>.from(competences),
      imageUrl: imageUrl, 
      internshipId: internshipId,
    );
  }

  // Empty model
  factory CondidatureModel.empty() {
    return CondidatureModel(
      id: '',
      department: '',
      doctorName: '',
      hospital: '',
      startDate: DateTime.now(),
      niveauStage: '',
      duree: '',
      objectifs: [],
      competences: [],
      imageUrl: null,
      internshipId: '',
    );
  }

  @override
  String toString() {
    return 'CondidatureModel{id: $id, department: $department, doctorName: $doctorName, hospital: $hospital, startDate: $startDate, niveauStage: $niveauStage, duree: $duree, objectifs: $objectifs, competences: $competences, imageUrl: $imageUrl,internshipId: $internshipId}';
  }
}