import 'package:med/core/enums/roles.dart';
import 'package:med/core/features/etudiant/domain/entities/etudiant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel extends Student {
  StudentModel({
    required super.id,
    required super.email,
    required super.nom,
    required super.prenom,
    required super.phone,
    required super.adresse,
    required super.annee,
    required super.universite,
    required super.birthday,
    required super.photoUrl,
    required super.documents,
    required super.role,
  });

  /// Convert Firestore map → StudentModel
  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      nom: map['nom'] ?? '',
      prenom: map['prenom'] ?? '',
      phone: map['phone'] ?? '',
      adresse: map['adresse'] ?? '',
      annee: map['annee'] ?? '',
      universite: map['universite'] ?? '',

      ///  Convert Timestamp to string
      birthday: map['birthday'] is Timestamp
          ? (map['birthday'] as Timestamp).toDate().toIso8601String()
          : (map['birthday'] ?? ''),

       photoUrl: map['photoUrl']?.toString().trim() ?? '',       // default empty string
       documents: List<String>.from(map['documents'] ?? []),  // default empty list


      ///  Handle role safely
      role: map['role'] != null
          ? Student.roleFromString(map['role'])
          : UserRole.etudiant,
    );
  }

  /// Convert StudentModel → Firestore map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'nom': nom,
      'prenom': prenom,
      'phone': phone,
      'adresse': adresse,
      'annee': annee,
      'universite': universite,
      'birthday': birthday,
      'photoUrl': photoUrl,
      'documents': documents,
      'role': role.name,
    };
  }
}
