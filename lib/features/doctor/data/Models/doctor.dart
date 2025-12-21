import 'package:med/core/enums/roles.dart';



class DoctorModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String specialty;
  final UserRole role;

  DoctorModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.specialty,
    required this.role,
  });

  factory DoctorModel.fromMap(Map<String, dynamic> map, String id) {
    return DoctorModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      specialty: map['specialty'] ?? '',
      role: UserRole.values.firstWhere(
        (r) => r.name.toLowerCase() == ((map['role'] ?? 'medecin').toString().toLowerCase()),
        orElse: () => UserRole.medecin,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'specialty': specialty,
      'role': role.name,
    };
  }
}
