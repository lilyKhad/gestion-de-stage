// data/models/internship_model.dart
import 'package:med/core/features/Internship/domain/entity/internship.dart';


class InternshipModel extends Internship {
  InternshipModel({
    required String id,
    required String department,
    required String doctorName,
    required String hospital,
    required DateTime startDate,
    String? notes,
  }) : super(
          id: id,
          department: department,
          doctorName: doctorName,
          hospital: hospital,
          startDate: startDate,
          notes: notes,
        );

  factory InternshipModel.fromEntity(Internship internship) {
    return InternshipModel(
      id: internship.id,
      department: internship.department,
      doctorName: internship.doctorName,
      hospital: internship.hospital,
      startDate: internship.startDate,
      notes: internship.notes,
    );
  }
}