import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med/core/features/Condidature/domain/entity/condidature.dart';
import 'package:med/core/features/Condidature/providers/condidature_providers.dart';
import 'package:med/core/features/etudiant/presentation/appbare.dart';

class CondidatureDetailScreen extends ConsumerWidget {
  final String internshipId;

  const CondidatureDetailScreen({super.key, required this.internshipId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final condidatureAsync = ref.watch(getCondidatureProvider(internshipId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarEtudiant(),
      body: condidatureAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 64),
              const SizedBox(height: 16),
              Text(
                'Erreur: ${error.toString()}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.refresh(getCondidatureProvider(internshipId)),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
        data: (condidature) {
          if (condidature == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Aucune candidature trouvée',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pour le stage: $internshipId',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(30.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(50, 50, 93, 0.25),
                      blurRadius: 27,
                      spreadRadius: -5,
                      offset: Offset(0, 13),
                    ),
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.3),
                      blurRadius: 16,
                      spreadRadius: -8,
                      offset: Offset(0, 8),
                    )
                  ]),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    _buildInternshipSection(context, condidature),
                    const SizedBox(height: 25),
                    _buildStageDescriptionSection(condidature),
                    const SizedBox(height: 25),
                    _buildCompetencesSection(condidature),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInternshipSection(BuildContext context, CondidatureEntity c) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: Text info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                c.department.toUpperCase(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                c.hospital.toUpperCase(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),

        // Right: Button
        SizedBox(
          height: 40,
          width: 120,
          child: ElevatedButton(
            onPressed: () {
              _showPostulerDialog(context, c);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Postuler',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStageDescriptionSection(CondidatureEntity c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Encadrant: ${c.doctorName}',
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            Text(
              'Niveau requis: ${c.niveauStage}',
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            Text(
              'Durée: ${c.duree}',
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            Text(
              'Date de début: ${_formatDate(c.startDate)}',
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Divider(),
        if (c.objectifs.isNotEmpty) ...[
          const Text(
            'Objectifs:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...c.objectifs.where((o) => o.isNotEmpty).map(
                (o) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('• $o'),
                ),
              ),
        ],
      ],
    );
  }

  Widget _buildCompetencesSection(CondidatureEntity c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Compétences développées :',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...c.competences.where((comp) => comp.isNotEmpty).map(
              (comp) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 14)),
                    Expanded(
                      child: Text(
                        comp,
                        style: const TextStyle(fontSize: 14, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showPostulerDialog(BuildContext context, CondidatureEntity c) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Postuler'),
        content: Text('Voulez-vous postuler pour le stage ${c.department}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Add your postuler logic here
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Candidature envoyée pour ${c.department}'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating, // This makes it float
                  margin: const EdgeInsets.only(
                    bottom: 20.0,
                    left: 20.0,
                    right: 20.0,
                    top: 10.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12.0), // Rounded borders
                  ),
                  duration: const Duration(
                      seconds: 3), // Optional: control display time
                ),
              );
            },
            child: const Text('votre condidature a été bien enregistré'),
          ),
        ],
      ),
    );
  }
}
