
import 'package:med/core/enums/roles.dart';


class HopitalEntity {
  final String id;
  final String name;
  final String email;
  final String adresse;
  final UserRole role;
  final String phone;
  final List<String> services;

  HopitalEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.adresse,
    this.role = UserRole.hopital,
    required this.phone,
    required this.services,
  });

  /// ✅ From Firestore / JSON
  factory HopitalEntity.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return HopitalEntity(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      adresse: map['adresse'] ?? '',
       role: roleFromString(map['role'] ?? 'hopital'),
      phone: map['phone'] ?? '',
      services: List<String>.from(map['services'] ?? []),
    );
  }

 

  HopitalEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? adresse,
    UserRole? role,
    String? phone,
    List<String>? services,
  }) {
    return HopitalEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      adresse: adresse ?? this.adresse,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      services: services ?? this.services,
    );
  }
  
  bool get isEtudiant => role == UserRole.etudiant;
  bool get isMedcin => role == UserRole.medecin;
  bool get isDoyen => role == UserRole.doyen;
  bool get isHopital => role == UserRole.hopital;

  String get roleString {
    switch (role) {
      case UserRole.etudiant: return 'etudiant';
      case UserRole.medecin: return 'medcin';
      case UserRole.doyen: return 'doyen';
      case UserRole.hopital: return 'etablissement';
    }
  }

  static UserRole roleFromString(String roleString) {
    switch (roleString.toLowerCase()) {
      case 'etudiant': return UserRole.etudiant;
      case 'medcin': return UserRole.medecin;
      case 'doyen': return UserRole.doyen;
      case 'etablissement': return UserRole.hopital;
      default: return UserRole.etudiant;
    }
  }
}
