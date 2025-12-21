

import 'package:med/core/enums/roles.dart';



import 'package:cloud_firestore/cloud_firestore.dart';

class AdminEntity {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String phone;
  final String pictureUrl;
  final String adresse;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AdminEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    required this.pictureUrl,
    required this.adresse,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor pour créer un AdminEntity depuis une Map Firestore
  factory AdminEntity.fromMap(Map<String, dynamic> map, String id) {
    return AdminEntity(
      id: id,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      role: _parseUserRole(map['role'] as String?),
      phone: map['phone'] as String? ?? '',
      pictureUrl: map['pictureUrl'] as String? ?? '',
      adresse: map['adresse'] as String? ?? '',
      createdAt: map['createdAt'] is Timestamp 
          ? (map['createdAt'] as Timestamp).toDate()
          : map['createdAt'] != null 
              ? DateTime.parse(map['createdAt'].toString())
              : null,
      updatedAt: map['updatedAt'] is Timestamp
          ? (map['updatedAt'] as Timestamp).toDate()
          : map['updatedAt'] != null
              ? DateTime.parse(map['updatedAt'].toString())
              : null,
    );
  }

  // Factory constructor depuis un DocumentSnapshot Firestore
  factory AdminEntity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AdminEntity.fromMap(data, doc.id);
  }

  // Méthode pour convertir l'AdminEntity en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': _roleToString(role),
      'phone': phone,
      'pictureUrl': pictureUrl,
      'adresse': adresse,
      if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
      'updatedAt': Timestamp.fromDate(updatedAt ?? DateTime.now()),
    };
  }

  // Méthode pour convertir en Map avec l'ID inclus
  Map<String, dynamic> toMapWithId() {
    return {
      'id': id,
      ...toMap(),
    };
  }

  // Helper pour parser le UserRole depuis String
  static UserRole _parseUserRole(String? roleString) {
    if (roleString == null) return UserRole.doyen;
    
    switch (roleString.toLowerCase()) {
      case 'admin':
      case 'doyen':
        return UserRole.doyen;
      case 'etudiant':
        return UserRole.etudiant;
      case 'medecin':
        return UserRole.medecin;
      case 'hopital':
      case 'etablissement':
        return UserRole.hopital;
      default:
        return UserRole.doyen;
    }
  }

  // Helper pour convertir UserRole en String
  static String _roleToString(UserRole role) {
    switch (role) {
      case UserRole.doyen:
        return 'doyen';
      case UserRole.etudiant:
        return 'etudiant';
      case UserRole.medecin:
        return 'medecin';
      case UserRole.hopital:
        return 'hopital';
    }
  }

  // Méthode copyWith améliorée
  AdminEntity copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    String? phone,
    String? pictureUrl,
    String? adresse,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AdminEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      pictureUrl: pictureUrl ?? this.pictureUrl,
      adresse: adresse ?? this.adresse,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }


  // Override de toString pour le débogage
  @override
  String toString() {
    return 'AdminEntity(id: $id, name: $name, email: $email, role: $role)';
  }

  // Override de == et hashCode pour comparer les objets
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is AdminEntity &&
        other.id == id &&
        other.email == email;
  }

  @override
  int get hashCode => Object.hash(id, email);
}

