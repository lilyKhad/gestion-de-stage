// lib/data/models/student_model.dart
import 'package:med/core/features/etudiant/domain/entities/etudiant.dart';


class StudentModel extends Student {
  const StudentModel({
    required String id,
    required String email,
    required String nom,
    required String prenom,
    String? phone,
    String? adresse,
    String? annee,
    String? universite,
    String? birthday,
    String? photoUrl,
    List<String> documents = const [],
    bool isProfileComplete = false,
  }) : super(
          id: id,
          email: email,
          nom: nom,
          prenom: prenom,
          phone: phone,
          adresse: adresse,
          annee: annee,
          universite: universite,
          birthday: birthday,
          photoUrl: photoUrl,
          documents: documents,
          isProfileComplete: isProfileComplete,
        );

  factory StudentModel.fromJson(Map<String, dynamic> json, String id) {
    return StudentModel(
      id: id,
      email: json['email'] ?? '',
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      phone: json['phone'],
      adresse: json['adresse'],
      annee: json['annee'],
      universite: json['universite'],
      birthday: json['birthday'],
      photoUrl: json['photoUrl'],
      documents: List<String>.from(json['documents'] ?? []),
      isProfileComplete: json['isProfileComplete'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      'isProfileComplete': isProfileComplete,
      'role': 'etudiant', // Always set role for students
    };
  }

  factory StudentModel.fromEntity(Student student) {
    return StudentModel(
      id: student.id,
      email: student.email,
      nom: student.nom,
      prenom: student.prenom,
      phone: student.phone,
      adresse: student.adresse,
      annee: student.annee,
      universite: student.universite,
      birthday: student.birthday,
      photoUrl: student.photoUrl,
      documents: student.documents,
      isProfileComplete: student.isProfileComplete,
    );
  }
}