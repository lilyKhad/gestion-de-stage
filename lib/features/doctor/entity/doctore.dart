import 'package:med/core/enums/roles.dart';

class DoctorEntity {
  final String id;
  final String name;
  final String email;
  final String specialty;
  final UserRole role;
  final String phone;
  final String pictureUrl;
  final String adresse;
  final List<String> internshipIds; 

  DoctorEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.specialty,
    required this.role,
    required this.phone,
    required this.pictureUrl,
    required this.adresse,
    required this.internshipIds,
  });

  DoctorEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? specialty,
    UserRole? role,
    String? phone,
    String? pictureUrl,
    String? adresse,
    List<String>? internshipIds,
  }) {
    return DoctorEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      specialty: specialty ?? this.specialty,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      pictureUrl: pictureUrl ?? this.pictureUrl,
      adresse: adresse ?? this.adresse,
      internshipIds: internshipIds ?? this.internshipIds,
    );
  }
}
