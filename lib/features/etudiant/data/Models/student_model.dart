import 'package:med/core/enums/roles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med/features/etudiant/domain/entities/etudiant.dart';
import 'package:med/features/etudiant/domain/entities/documents.dart';

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
    super.documents,
    required super.role,
  });

  /// Convert Firestore map → StudentModel
  factory StudentModel.fromMap(Map<String, dynamic> map, [String? docId]) {
    return StudentModel(
      // Use docId if provided, otherwise use map['id']
      id: docId ?? map['id'] ?? '',
      email: map['email'] ?? '',
      nom: map['nom'] ?? '',
      prenom: map['prenom'] ?? '',
      phone: map['phone'] ?? '',
      adresse: map['adresse'] ?? '',
      annee: map['annee'] ?? '',
      universite: map['universite'] ?? '',

      /// Convert Timestamp to string
      birthday: map['birthday'] is Timestamp
          ? (map['birthday'] as Timestamp).toDate().toIso8601String()
          : (map['birthday']?.toString() ?? ''),

      photoUrl: map['photoUrl']?.toString().trim() ?? '',

      /// Convert List<dynamic> to List<StudentDocument>
      documents: map['documents'] != null
          ? List<StudentDocument>.from(
              (map['documents'] as List).map(
                (x) => StudentDocument.fromMap(x as Map<String, dynamic>),
              ),
            )
          : <StudentDocument>[], // Default empty list

      /// Handle role safely
      role: map['role'] != null
          ? Student.roleFromString(map['role'])
          : UserRole.etudiant,
    );
  }

  /// Alternative constructor from DocumentSnapshot
  factory StudentModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>? ?? {};
    return StudentModel.fromMap(data, snapshot.id);
  }

  /// Convert StudentModel → Firestore map
  @override
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
      // Convert List<StudentDocument> to List<Map>
      'documents': documents?.map((doc) => doc.toMap()).toList(),
      'role': role.name,
    };
  }

  /// Create a StudentModel from Student entity
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
      documents: List<StudentDocument>.from(student.documents as Iterable),
      role: student.role,
    );
  }

  /// Convert to Student entity (though StudentModel already extends Student)
  Student toEntity() {
    return Student(
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
      documents: List<StudentDocument>.from(documents as Iterable),
      role: role,
    );
  }

  /// Copy with method for StudentModel
  @override
  StudentModel copyWith({
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
    List<StudentDocument>? documents,
    UserRole? role,
  }) {
    return StudentModel(
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
}