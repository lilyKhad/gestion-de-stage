import 'package:med/features/Internship/data/model/internship.dart';
import 'package:med/features/Internship/domain/entity/internship.dart';

class InternshipMapper {
  static InternshipModel toModel(Internship entity) {
    return InternshipModel(
      id: entity.id,
      department: entity.department,
      doctorId: entity.doctorId,
      doctorName: entity.doctorName,
      hospital: entity.hospital,
      startDate: entity.startDate,
      duree: entity.duree,
      notes: entity.notes,
      niveauStage: entity.niveauStage,
      objectifs: entity.objectifs,
      competences: entity.competences,
      status: entity.status,
    );
  }

  static Internship toEntity(InternshipModel model) {
    return Internship(
      id: model.id,
      department: model.department,
      doctorId: model.doctorId,
      doctorName: model.doctorName,
      hospital: model.hospital,
      startDate: model.startDate,
      duree: model.duree,
      notes: model.notes,
      niveauStage: model.niveauStage,
      objectifs: model.objectifs,
      competences: model.competences,
      status: model.status,
    );
  }
}