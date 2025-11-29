import 'package:med/core/enums/roles.dart';
import 'package:med/core/features/Condidature/domain/entity/condidature.dart';


class Student {
  final String id;
  final String email;
  final String nom;
  final String prenom;
  final String phone;
  final String adresse;
  final String annee;
  final String universite;
  final String birthday;
  final String photoUrl;
  final List<String> documents;
  final UserRole role;

  const Student({
    required this.id,
    required this.email,
    required this.nom,
    required this.prenom,
    required this.phone,
    required this.adresse,
    required this.annee,
    required this.universite,
    required this.birthday,
    required this.photoUrl,
    required this.documents,
    this.role = UserRole.etudiant, 
  });

  // CopyWith method for immutability
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
    List<CondidatureEntity>? condidatures,
    UserRole? role,
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
      documents: documents ?? List<String>.from(this.documents),
       role: role ?? this.role,
    );
  }

  // Helper methods to check role
  bool get isEtudiant => role == UserRole.etudiant;
  bool get isMedcin => role == UserRole.medcin;
  bool get isDoyen => role == UserRole.doyen;
  bool get isEtablissement => role == UserRole.etablissement;

  // Get role as string
  String get roleString {
    switch (role) {
      case UserRole.etudiant:
        return 'Étudiant';
      case UserRole.medcin:
        return 'Médecin';
      case UserRole.doyen:
        return 'Doyen';
      case UserRole.etablissement:
        return 'Établissement';
    }
  }

  // Convert from string to UserRole
  static UserRole roleFromString(String roleString) {
    switch (roleString.toLowerCase()) {
      case 'etudiant':
        return UserRole.etudiant;
      case 'medcin':
        return UserRole.medcin;
      case 'doyen':
        return UserRole.doyen;
      case 'etablissement':
        return UserRole.etablissement;
      default:
        return UserRole.etudiant;
    }
  }

  @override
  String toString() {
    return 'Student{id: $id, email: $email, nom: $nom, prenom: $prenom, phone: $phone, adresse: $adresse, annee: $annee, universite: $universite, birthday: $birthday, photoUrl: $photoUrl, documents: $documents,  role: $role}';
  }

  // Equality check
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Student &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          nom == other.nom &&
          prenom == other.prenom &&
          phone == other.phone &&
          adresse == other.adresse &&
          annee == other.annee &&
          universite == other.universite &&
          birthday == other.birthday &&
          photoUrl == other.photoUrl &&
          documents == other.documents &&
          role == other.role;

  @override
  int get hashCode =>
      id.hashCode ^
      email.hashCode ^
      nom.hashCode ^
      prenom.hashCode ^
      phone.hashCode ^
      adresse.hashCode ^
      annee.hashCode ^
      universite.hashCode ^
      birthday.hashCode ^
      photoUrl.hashCode ^
      documents.hashCode ^
      role.hashCode;
}