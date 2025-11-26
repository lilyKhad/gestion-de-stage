// lib/domain/entities/student.dart
import 'package:equatable/equatable.dart';

class Student extends Equatable {
  final String id;
  final String email;
  final String nom;
  final String prenom;
  final String? phone;
  final String? adresse;
  final String? annee;
  final String? universite;
  final String? birthday;
  final String? photoUrl;
  final List<String> documents;
  final bool isProfileComplete;

  const Student({
    required this.id,
    required this.email,
    required this.nom,
    required this.prenom,
    this.phone,
    this.adresse,
    this.annee,
    this.universite,
    this.birthday,
    this.photoUrl,
    this.documents = const [],
    this.isProfileComplete = false,
  });

  Student copyWith({
    String? id,
    String? email,
    String? nom,
    String? prenom,
    String? phone,
    String? adresse,
    String? annee,
    String? universite,
    String? birthday,
    String? photoUrl,
    List<String>? documents,
    bool? isProfileComplete,
  }) {
    return Student(
      id: id ?? this.id,
      email: email ?? this.email,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      phone: phone ?? this.phone,
      adresse: adresse ?? this.adresse,
      annee: annee ?? this.annee,
      universite: universite ?? this.universite,
      birthday: birthday ?? this.birthday,
      photoUrl: photoUrl ?? this.photoUrl,
      documents: documents ?? this.documents,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        nom,
        prenom,
        phone,
        adresse,
        annee,
        universite,
        birthday,
        photoUrl,
        documents,
        isProfileComplete,
      ];
}