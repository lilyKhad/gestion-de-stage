import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med/features/Internship/domain/entity/internship.dart';
import 'package:med/features/auth/provider/loginProviders.dart';
import 'package:med/features/doyen/entity/admin.dart'; 

final allStudentsProvider = StreamProvider<List<QueryDocumentSnapshot>>((ref) {
  return FirebaseFirestore.instance
      .collection('users')
      .where('role', isEqualTo: 'etudiant')
      .snapshots()
      .map((snapshot) => snapshot.docs);
});

// 2. Récupérer tous les hôpitaux (Établissements)
final allHospitalsProvider = StreamProvider<List<QueryDocumentSnapshot>>((ref) {
  return FirebaseFirestore.instance
      .collection('users') // Ou une collection 'hospitals' selon votre structure
      .where('role', isEqualTo: 'hopital')
      .snapshots()
      .map((snapshot) => snapshot.docs);
});

// 3. Récupérer toutes les candidatures ACCEPTÉES (pour savoir qui a un stage)
final acceptedApplicationsProvider = StreamProvider<List<QueryDocumentSnapshot>>((ref) {
  return FirebaseFirestore.instance
      .collection('applications') // Assurez-vous que cette collection existe
      .where('status', isEqualTo: 'accepted')
      .snapshots()
      .map((snapshot) => snapshot.docs);
});

// 4. Récupérer tous les stages (pour compter les services)
final allInternshipsProvider = StreamProvider<List<Internship>>((ref) {
  return FirebaseFirestore.instance.collection('internships').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) => Internship.fromMap(doc.data())).toList();
  });
});



final currentDeanStreamProvider = StreamProvider<AdminEntity?>((ref) {
 
  final authState = ref.watch(authStateProvider);
  final user = authState.value;

  if (user == null) {
    return Stream.value(null);
  }

  if (user.role != 'admin' && user.role != 'doyen') {
    return Stream.value(null);
  }

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.id) 
      .snapshots()
      .map((doc) {
        if (!doc.exists) {
          return null; // Cas rare où le doc n'existe pas
        }
        // Conversion vers le modèle
        return AdminEntity.fromMap(doc.data()!, doc.id);
      });
});