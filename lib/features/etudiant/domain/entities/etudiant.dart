import 'package:med/core/enums/roles.dart';
import 'package:med/features/etudiant/domain/entities/documents.dart';



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
  final List<StudentDocument>? documents; 
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
    this.documents,
    this.role = UserRole.etudiant,
  });


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
      'role': roleString, 
      'documents': documents?.map((doc) => doc.toMap()).toList(), 
    };
  }

 
  factory Student.fromMap(Map<String, dynamic> map, String docId) {
    return Student(
      id: docId, 
      email: map['email'] ?? '',
      nom: map['nom'] ?? '',
      prenom: map['prenom'] ?? '',
      phone: map['phone'] ?? '',
      adresse: map['adresse'] ?? '',
      annee: map['annee'] ?? '',
      universite: map['universite'] ?? '',
      birthday: map['birthday'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      role: roleFromString(map['role'] ?? 'etudiant'),
      documents: map['documents'] != null
          ? List<StudentDocument>.from(
              (map['documents'] as List).map(
                (x) => StudentDocument.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
    );
  }

  // --- COPY WITH ---

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
    List<StudentDocument>? documents, // Updated Type
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
      documents: documents ?? List<StudentDocument>.from(this.documents as Iterable),
      role: role ?? this.role,
    );
  }

  // --- HELPERS ---

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

  @override
  String toString() {
    return 'Student{id: $id, nom: $nom, documents: ${documents?.length} files}';
  }
}