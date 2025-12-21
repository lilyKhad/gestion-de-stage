import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:med/features/etudiant/domain/entities/etudiant.dart';
import 'package:med/features/etudiant/presentation/widgets/ajouter_documents_screen.dart';
import 'package:med/features/etudiant/presentation/widgets/placeholder_view.dart';
import 'package:med/features/etudiant/presentation/widgets/sidebar_wrapper.dart';
import 'package:med/features/etudiant/presentation/widgets/student_condidature.dart';
import 'package:med/features/etudiant/presentation/widgets/student_personal_info_card.dart';
import 'package:med/features/etudiant/providers/student_providers.dart';

class StudentProfileScreen extends ConsumerStatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  ConsumerState<StudentProfileScreen> createState() =>
      _StudentProfileScreenState();
}

class _StudentProfileScreenState extends ConsumerState<StudentProfileScreen> {
  // LE CHEMIN STATIQUE UNIQUE
  final String _localProfilePhotoPath = 'assets/Apropos/etudiante.jpg';

  // Fonction simplifiée qui retourne toujours le chemin local
  String _getOptimizedPhotoUrl(String _) {
    return _localProfilePhotoPath;
  }

  // Désactivé car on veut du statique
  Future<void> _pickAndUpdateProfileImage() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content:
              Text('La modification de photo est désactivée (Mode Statique)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SidebarWrapper(
      builder: (context, ref, selectedIndex) {
        return _buildMainContent(context, ref, selectedIndex);
      },
    );
  }

  Widget _buildMainContent(
      BuildContext context, WidgetRef ref, int selectedIndex) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
          body: Center(child: Text('Utilisateur non connecté')));
    }

    final studentId = currentUser.uid;
    final studentAsync = ref.watch(studentProvider(studentId));

    return Container(
      color: Colors.white,
      child: studentAsync.when(
        loading: () => _buildLoadingState(),
        error: (error, stack) =>
            _buildErrorState(context, error, studentId, ref),
        data: (either) {
          return either.fold(
            (failure) => _buildFailureState(context, failure, studentId, ref),
            (student) => _routeContent(selectedIndex, student),
          );
        },
      ),
    );
  }

  Widget _routeContent(int index, Student student) {
    // On crée un objet étudiant qui utilise l'image locale pour l'affichage dans la carte d'infos
    final staticStudent = Student(
      id: student.id,
      nom: student.nom,
      prenom: student.prenom,
      email: student.email,
      universite: student.universite,
      annee: student.annee,
      photoUrl: _localProfilePhotoPath, // FORCE L'ASSET ICI
      birthday: student.birthday,
      phone: student.phone,
      adresse: student.adresse,
    );

    switch (index) {
      case 0:
        return const CondidatureMainContent();
      case 1:
        return const AjouterDocumentScreen();
      case 3:
        return StudentPersonalInfoCard(
          student: staticStudent,
          onEditImage:
              null, // On passe null pour cacher/désactiver le bouton d'édition
        );
      case 4:
        return const PlaceholderView(title: 'Paramètres');
      default:
        return const PlaceholderView(title: 'Tableau de bord');
    }
  }

  // AFFICHAGE DE L'IMAGE LOCALE UNIQUEMENT
  Widget _buildProfileImage(String _ignoredUrl, String _ignoredInitials) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      child: ClipOval(
        child: Image.asset(
          _localProfilePhotoPath,
          width: 116,
          height: 116,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Si le fichier n'existe pas dans vos assets
            return const Icon(Icons.person, size: 60);
          },
        ),
      ),
    );
  }

  // --- États de chargement et erreurs mis à jour pour utiliser l'image statique ---

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildProfileImage('', ''),
          const SizedBox(height: 24),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildErrorState(
      BuildContext context, Object error, String studentId, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildProfileImage('', ''),
          const SizedBox(height: 24),
          const Text('Erreur de chargement'),
          ElevatedButton(
            onPressed: () => ref.refresh(studentProvider(studentId)),
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildFailureState(
      BuildContext context, Object failure, String studentId, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildProfileImage('', ''),
          const SizedBox(height: 24),
          Text('Données non disponibles : $failure'),
          ElevatedButton(
            onPressed: () => ref.refresh(studentProvider(studentId)),
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }
}
