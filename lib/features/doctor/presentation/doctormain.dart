import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// Vos imports existants
import 'package:med/features/application/providers/applicationprovider.dart';
import 'package:med/features/auth/provider/loginProviders.dart';
import 'package:med/features/doctor/presentation/appBareDoctor.dart';
import 'package:med/features/doctor/presentation/details_etudiant.dart'; // Votre dialog
import 'package:med/features/doctor/presentation/sidebare.dart'; // Votre fichier sidebar

// ---------------------------------------------------------------------------
// DASHBOARD BODY (Transformé en Stateful pour gérer la navigation)
// ---------------------------------------------------------------------------
class DashboardBody extends ConsumerStatefulWidget {
  const DashboardBody({super.key});

  @override
  ConsumerState<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends ConsumerState<DashboardBody> {
  // L'index 1 correspond à "Mes Etudiants" (comme sur votre image)
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    // Récupération de l'ID du docteur via Riverpod
    final authState = ref.watch(authStateProvider);
    final user = authState.value;
    final String doctorId = user?.id ?? "";

    return Scaffold(
      appBar: const AppbarDoctor(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -----------------------
          // 1. SIDEBAR (GAUCHE)
          // -----------------------
          SizedBox(
            width: 250,
            child: MedStageSidebar(
              onIndexChanged: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),

          // -----------------------
          // 2. CONTENU PRINCIPAL (DROITE)
          // -----------------------
          Expanded(
            child: Container(
              color: const Color(0xFFF9FAFC), // Fond gris très clair
              padding: const EdgeInsets.all(30.0),
              // On appelle la fonction qui choisit le contenu selon l'index
              child: _buildPageContent(_selectedIndex, doctorId),
            ),
          ),
        ],
      ),
    );
  }

  // Fonction qui retourne le widget à afficher selon le menu cliqué
  Widget _buildPageContent(int index, String doctorId) {
    switch (index) {
      case 0:
        return const Center(child: Text("Page Dashboard (À implémenter)"));
      
      case 1: 
        // --- C'est ici que s'affiche votre tableau "Mes Etudiants" ---
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Suivi de vos étudiants :",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Le Container blanc avec l'ombre
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                // Appel du Widget Tableau défini plus bas
                child: StudentsTable(doctorId: doctorId),
              ),
            ],
          ),
        );

      case 2:
        return const Center(child: Text("Page Les Demandes (À implémenter)"));
      case 3:
        return const Center(child: Text("Page Informations Personnelles (À implémenter)"));
      case 4:
        return const Center(child: Text("Page Paramètres (À implémenter)"));
      default:
        return const Center(child: Text("Page Inconnue"));
    }
  }
}

// ---------------------------------------------------------------------------
// TABLE WIDGET (Votre tableau existant, inchangé)
// ---------------------------------------------------------------------------
class StudentsTable extends ConsumerWidget {
  final String doctorId;
  const StudentsTable({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the new provider
    final applicationsAsync = ref.watch(doctorApplicationsProvider(doctorId));

    return SizedBox(
      width: double.infinity,
      child: applicationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (rows) {
          if (rows.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: Text("Aucune demande trouvée."),
            );
          }

          return DataTable(
            headingRowColor: WidgetStateProperty.all(Colors.transparent),
            columnSpacing: 20,
            horizontalMargin: 10,
            columns: const [
              DataColumn(label: Text('DATE', style: TextStyle(color: Colors.grey, fontSize: 12))),
              DataColumn(label: Text('NOM ET PRENOM', style: TextStyle(color: Colors.grey, fontSize: 12))),
              DataColumn(label: Text('HOPITAL', style: TextStyle(color: Colors.grey, fontSize: 12))),
              DataColumn(label: Text('DURÉE', style: TextStyle(color: Colors.grey, fontSize: 12))),
              DataColumn(label: Text('STATUS', style: TextStyle(color: Colors.grey, fontSize: 12))),
              DataColumn(label: Text('ACTION', style: TextStyle(color: Colors.grey, fontSize: 12))),
            ],
            rows: rows.map((row) {
              final dateFormat = DateFormat('d MMM yyyy');
              final duration = row.endDate.difference(row.startDate).inDays;

              return DataRow(cells: [
                DataCell(Text(dateFormat.format(row.startDate))),
                DataCell(Text(row.studentName, style: const TextStyle(fontWeight: FontWeight.w500))),
                DataCell(Text(row.hospitalName)),
                DataCell(Text("$duration jours")),
                DataCell(_buildStatusChip(row.status)), 
                
                // BOUTON VOIR PLUS
                DataCell(
                  ElevatedButton(
                    onPressed: () {
                      // Afficher la Popup Details
                      showDialog(
                        context: context,
                        builder: (context) => StudentDetailsDialog(
                          applicationId: row.id,
                          studentId: row.studentId,
                          studentName: row.studentName,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      minimumSize: const Size(80, 30),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    ),
                    child: const Text("Voir Plus", style: TextStyle(fontSize: 12)),
                  ),
                ),
              ]);
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildStatusChip(String statusKey) {
    bool isValidated = statusKey.toLowerCase().contains('accept') || statusKey.toLowerCase().contains('valid'); 
    bool isPending = statusKey.toLowerCase().contains('pending');
    bool isRejected = statusKey.toLowerCase().contains('reject');

    Color bgColor = const Color(0xFFFFF3CD); // Default Beige (En Cours)
    Color textColor = const Color(0xFF664D03);

    if (isValidated) {
      bgColor = const Color(0xFFD1E7DD); // Green
      textColor = const Color(0xFF0F5132);
    } else if (isRejected) {
      bgColor = const Color(0xFFF8D7DA); // Red
      textColor = const Color(0xFF842029);
    } else if (isPending) {
      bgColor = Colors.blue.shade50;
      textColor = Colors.blue.shade800;
    }

    String displayText = statusKey.replaceAll('_', ' ').toUpperCase();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }
}