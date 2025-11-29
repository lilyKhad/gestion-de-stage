import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:med/core/features/etudiant/domain/entities/etudiant.dart';
import 'package:med/core/features/etudiant/presentation/widgets/ajouter_documents_screen.dart';
import 'package:med/core/features/etudiant/presentation/widgets/student_condidature.dart';
import 'package:med/core/features/etudiant/presentation/widgets/student_personal_info_card.dart';
import 'package:med/core/features/etudiant/presentation/widgets/placeholder_view.dart';
import 'package:med/core/features/etudiant/presentation/widgets/sidebar_wrapper.dart';
import 'package:med/core/features/etudiant/providers/student_providers.dart';

class StudentProfileScreen extends ConsumerWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SidebarWrapper(
      builder: (context, ref, selectedIndex) {
        return _buildMainContent(context, ref, selectedIndex);
      },
    );
  }

  Widget _buildMainContent(BuildContext context, WidgetRef ref, int selectedIndex) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Container(
        color: Colors.white, // White background
        child: const Center(
          child: Text('Utilisateur non connecté', style: TextStyle(fontSize: 16, color: Colors.red)),
        ),
      );
    }

    final studentId = currentUser.uid;
    final studentAsync = ref.watch(studentProvider(studentId));

    return Container(
      color: Colors.white, // White background for entire screen
      child: studentAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Container(
          color: Colors.white, // White background for error state
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text('Erreur de chargement', style: TextStyle(fontSize: 18, color: Colors.grey[700], fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(error.toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.refresh(studentProvider(studentId)),
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          ),
        ),
        data: (either) {
          return Container(
            color: Colors.white, // White background for data state
            child: either.fold(
              (failure) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning_amber, color: Colors.orange, size: 48),
                    const SizedBox(height: 16),
                    Text('Données non disponibles', style: TextStyle(fontSize: 18, color: Colors.grey[700], fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(failure.toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.refresh(studentProvider(studentId)),
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
              (student) => _routeContent(selectedIndex, student),
            ),
          );
        },
      ),
    );
  }

  Widget _routeContent(int index, Student student) {
    // All child screens should have their own white background
    switch (index) {
      case 0: // Mes Candidatures
        return Container(
          color: Colors.white, // Ensure white background
          child: const CondidatureMainContent(),
        );
      case 1: // Ajouter Documents
        return Container(
          color: Colors.white, // Ensure white background
          child: const AjouterDocumentScreen(),
        );
      case 3: // Mes Informations
        return Container(
          color: Colors.white, // Ensure white background
          child: StudentPersonalInfoCard(student: student),
        );
      case 4: // Paramètres
        return Container(
          color: Colors.white, // Ensure white background
          child: const PlaceholderView(title: 'Paramètres'),
        );
      default:
        return Container(
          color: Colors.white, // Ensure white background
          child: const PlaceholderView(title: 'Tableau de bord'),
        );
    }
  }
}