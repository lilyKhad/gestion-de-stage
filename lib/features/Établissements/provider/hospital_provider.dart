import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med/features/%C3%89tablissements/domain/entity.dart';
import 'package:med/features/Internship/data/model/internship.dart';
import 'package:med/features/auth/provider/loginProviders.dart';


final hospitalInternshipsProvider = StreamProvider.family<List<InternshipModel>, String>((ref, hospitalName) {
  return FirebaseFirestore.instance
      .collection('internships')
      .where('hospital', isEqualTo: hospitalName) // Assure-toi que le nom correspond exactement
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => InternshipModel.fromMap(doc.data()))
          .toList());
});

// Récupérer le nombre de candidatures reçues pour cet hôpital
final hospitalApplicationsCountProvider = StreamProvider.family<int, String>((ref, hospitalName) {
  return FirebaseFirestore.instance
      .collection('applications') // Là où sont stockées les demandes des étudiants
      .where('useres', isEqualTo: hospitalName) // Il faut ajouter ce champ dans ApplicationEntity si pas présent
      .snapshots()
      .map((snapshot) => snapshot.docs.length);
});
// Ce provider écoute l'utilisateur connecté, puis va chercher ses détails dans la collection 'hospitals'
final currentHospitalStreamProvider = StreamProvider<HopitalEntity?>((ref) {
  final authState = ref.watch(authStateProvider);
  final user = authState.value;

  if (user == null) {
    print("DEBUG: Aucun utilisateur connecté");
    return Stream.value(null);
  }

  print("DEBUG: User ID connecté: ${user.id}");
  print("DEBUG: Role utilisateur: ${user.role}");

  if (user.role != 'hopital' && user.role != 'epsp') {
    print("DEBUG: Le rôle n'est pas 'hopital' (c'est ${user.role})");
    return Stream.value(null);
  }

  print("DEBUG: Recherche dans la collection 'hospitals' pour l'ID: ${user.id}");

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.id)
      .snapshots()
      .map((doc) {
        if (!doc.exists) {
          print("ERREUR CRITIQUE: Le document hospitals/${user.id} N'EXISTE PAS dans Firestore !");
          return null;
        }
        print("SUCCÈS: Profil hôpital trouvé: ${doc.data()}");
        // Assurez-vous que votre fromMap gère bien les champs
        return HopitalEntity.fromMap(doc.data()!, doc.id);
      });
});

final hospitalDoctorsProvider = StreamProvider.family<List<Map<String, dynamic>>, String>((ref, hospitalName) {
  return FirebaseFirestore.instance
      .collection('users')
      .where('role', isEqualTo: 'medecin')
      // Activez cette ligne si vous filtrez aussi par hôpital dans la collection users
      // .where('hospital', isEqualTo: hospitalName) 
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            data['uid'] = doc.id; // On sauvegarde l'ID du document
            return data;
          }).toList());
});