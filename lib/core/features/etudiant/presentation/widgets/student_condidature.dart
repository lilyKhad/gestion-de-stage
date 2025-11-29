import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:med/core/features/Condidature/domain/entity/condidature.dart';
import 'package:med/core/features/Condidature/providers/condidature_providers.dart';
import 'package:med/core/features/Internship/domain/entity/internship.dart';
import 'package:med/core/features/Internship/providers/ineternship_provider.dart';
import 'package:med/core/features/application/domain/entity/application.dart';
import 'package:med/core/features/application/providers/applicationprovider.dart';


class CondidatureMainContent extends ConsumerWidget {
  const CondidatureMainContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;

   if (user == null) {
      return const Scaffold(
        backgroundColor: Colors.white, // Set white background
        body: Center(
          child: Text('Vous devez être connecté pour voir vos candidatures'),
        ),
      );
    }
    final studentId = user.uid;
    final applicationsAsync = ref.watch(applicationsByStudentProvider(studentId));

    return Scaffold(
      backgroundColor: Colors.white, // Set white background
      body: Padding(
      padding: const EdgeInsets.all(16),
      child: Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Suivi de Vos demandes',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
              
              // Current Applications (pending)
              _buildSection(
                'Vos demandes en cours',
                applicationsAsync,
                ref,
                context, // Pass context here
                onlyPending: true,
              ),
              const SizedBox(height: 30),
              
              // History (approved/rejected/validated)
              _buildSection(
                'Historique de vos demandes',
                applicationsAsync,
                ref,
                context, // Pass context here
                onlyPending: false,
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildSection(
  String title,
  AsyncValue<List<ApplicationEntity>> applicationsAsync,
  WidgetRef ref,
  BuildContext context, {
  required bool onlyPending,
}) {
  return Container(
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        applicationsAsync.when(
          data: (applications) {
            // Filter by status only
            final filtered = onlyPending
                ? applications.where((app) => app.status == CondidatureStatus.pending).toList()
                : applications.where((app) => app.status != CondidatureStatus.pending).toList();

            if (filtered.isEmpty) {
              return const Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      'Aucune candidature trouvée',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                ),
              );
            }

            // Let _buildDataTable handle the internship validation
            return _buildDataTable(filtered, ref, context);
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 40),
                  const SizedBox(height: 8),
                  const Text(
                    'Erreur de chargement',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$e',
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
Widget _buildDataTable(List<ApplicationEntity> applications, WidgetRef ref, BuildContext context) {
  return Card(
    color: Colors.white,
    elevation: 2,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('DATE DU SÉJOUR', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('MÉDECIN', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('SERVICE', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('HOPITAL', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('DURÉE', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: applications.map((application) {
          final internshipAsync = ref.watch(internshipByIdProvider(application.internshipId));
          
          return DataRow(
            cells: [
              // DATE DU SÉJOUR
              DataCell(internshipAsync.when(
                data: (internship) => Text(
                  internship != null 
                    ? DateFormat('d MMMM yyyy', 'fr_FR').format(internship.startDate)
                    : 'Non disponible',
                ),
                loading: () => const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (error, stack) => const Text('Erreur', style: TextStyle(color: Colors.red)),
              )),
              
              // MÉDECIN
              DataCell(internshipAsync.when(
                data: (internship) => Text(internship?.doctorName ?? 'Non disponible'),
                loading: () => const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (error, stack) => const Text('Erreur', style: TextStyle(color: Colors.red)),
              )),
              
              // SERVICE
              DataCell(internshipAsync.when(
                data: (internship) => Text(internship?.department ?? 'Non disponible'),
                loading: () => const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (error, stack) => const Text('Erreur', style: TextStyle(color: Colors.red)),
              )),
              
              // HOPITAL
              DataCell(internshipAsync.when(
                data: (internship) => Text(internship?.hospital ?? 'Non disponible'),
                loading: () => const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (error, stack) => const Text('Erreur', style: TextStyle(color: Colors.red)),
              )),
              
              // DURÉE
              DataCell(internshipAsync.when(
                data: (internship) => Text(internship?.duree ?? 'Non disponible'),
                loading: () => const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (error, stack) => const Text('Erreur', style: TextStyle(color: Colors.red)),
              )),
              
              // STATUS
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusInfo(application.status).color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _getStatusInfo(application.status).text,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    ),
  );
}
 DataRow _buildDataRow(ApplicationEntity application, WidgetRef ref) {
  final internshipAsync = ref.watch(internshipByIdProvider(application.internshipId));

  return DataRow(
    cells: [
      // Date du séjour
      DataCell(internshipAsync.when(
        data: (internship) {
          if (internship == null) return const Text('N/A');
          final startDate = DateFormat('d MMMM, yyyy', 'fr_FR').format(internship.startDate);
          return Text(startDate);
        },
        loading: () => const Text('Chargement...'),
        error: (e, _) => const Text('Erreur'),
      )),

      // Médecin
      DataCell(internshipAsync.when(
        data: (internship) => Text(internship?.doctorName ?? 'N/A'),
        loading: () => const Text('Chargement...'),
        error: (e, _) => const Text('Erreur'),
      )),

      // Service
      DataCell(internshipAsync.when(
        data: (internship) => Text(internship?.department ?? 'N/A'),
        loading: () => const Text('Chargement...'),
        error: (e, _) => const Text('Erreur'),
      )),

      // Hôpital
      DataCell(internshipAsync.when(
        data: (internship) => Text(internship?.hospital ?? 'N/A'),
        loading: () => const Text('Chargement...'),
        error: (e, _) => const Text('Erreur'),
      )),

      // Durée
      DataCell(internshipAsync.when(
        data: (internship) => Text(internship?.duree ?? 'N/A'),
        loading: () => const Text('...'),
        error: (e, _) => const Text('Erreur'),
      )),

      // Status
      DataCell(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusInfo(application.status).color,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            _getStatusInfo(application.status).text,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
      ),
    ],
  );
}

  ({Color color, String text}) _getStatusInfo(CondidatureStatus status) {
    switch (status) {
      case CondidatureStatus.pending:
        return (color: Colors.orange.shade200, text: 'En Attente');
      case CondidatureStatus.accepted:
        return (color: Colors.green.shade200, text: 'Acceptée');
      case CondidatureStatus.rejected:
        return (color: Colors.red.shade200, text: 'Rejetée');
      case CondidatureStatus.validated:
        return (color: Colors.green.shade400, text: 'Validée');
      case CondidatureStatus.added:
        return (color: Colors.grey.shade300, text: 'Ajoutée');
    }
  }
}