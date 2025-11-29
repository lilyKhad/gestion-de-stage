import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med/core/features/Condidature/domain/entity/condidature.dart';
import 'package:med/core/features/Condidature/providers/condidature_providers.dart';
import 'package:med/core/features/Internship/domain/entity/internship.dart';
import 'package:med/core/features/Internship/providers/ineternship_provider.dart';
import 'package:med/core/features/application/domain/entity/application.dart';
import 'package:med/core/features/application/providers/applicationprovider.dart';
import 'package:med/core/features/etudiant/presentation/widgets/appbare.dart';

class CondidatureDetailScreen extends ConsumerWidget {
  final String internshipId;

  const CondidatureDetailScreen({super.key, required this.internshipId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch condidature by internshipId
    final condidatureAsync = ref.watch(getCondidatureProvider(internshipId));
    final internshipAsync = ref.watch(internshipByIdProvider(internshipId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppbarEtudiant(),
      body: condidatureAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildError(error, ref),
        data: (c) {
          if (c == null) {
            return _buildEmpty(internshipId);
          }

          return internshipAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => _buildError(error, ref),
            data: (internship) {
              if (internship == null) return _buildEmpty(internshipId);

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
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
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInternshipHeader(context, internship, c, ref),
                        const SizedBox(height: 25),
                        _buildStageDescriptionSection(c),
                        const SizedBox(height: 25),
                        _buildCompetencesSection(c),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ----------------------------
  // Error Widget
  // ----------------------------
  Widget _buildError(Object error, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 64),
          const SizedBox(height: 16),
          Text(
            'Erreur: $error',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.refresh(getCondidatureProvider(internshipId)),
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  // ----------------------------
  // Empty Widget
  // ----------------------------
  Widget _buildEmpty(String internshipId) {
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

  // ----------------------------
  // Internship Header
  // ----------------------------
  Widget _buildInternshipHeader(
    BuildContext context, Internship internship, CondidatureEntity c, WidgetRef ref) {
  
  // DEBUG: Check the condidature ID
  print('🔍 DEBUG _buildInternshipHeader:');
  print('   - Condidature c.id: "${c.id}"');
  print('   - Condidature c.department: "${c.department}"');
  print('   - Screen internshipId: "$internshipId"');
  print('   - Internship.id: "${internship.id}"');
  
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              internship.department.toUpperCase(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              internship.hospital.toUpperCase(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 40,
        width: 120,
        child: ElevatedButton(
          onPressed: () {
            // Use the screen's internshipId instead of c.id
            final correctId = internship.id; // Use the internship's ID
            print('🎯 Using internshipId: $correctId');
            _showPostulerDialog(context, c, ref, correctId);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text("Postuler"),
        ),
      ),
    ],
  );
}// ----------------------------
  // Stage Description
  // ----------------------------
  Widget _buildStageDescriptionSection(CondidatureEntity c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Encadrant: ${c.doctorName}'),
            Text('Niveau: ${c.niveauStage}'),
            Text('Durée: ${c.duree}'),
            Text('Début: ${_formatDate(c.startDate)}'),
          ],
        ),
        const SizedBox(height: 12),
        const Divider(),
        if (c.objectifs.isNotEmpty)
          ...c.objectifs.where((o) => o.isNotEmpty).map(
                (o) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('• $o'),
                ),
              ),
      ],
    );
  }

  // ----------------------------
  // Competences Section
  // ----------------------------
  Widget _buildCompetencesSection(CondidatureEntity c) {
    if (c.competences.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Compétences développées :', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...c.competences.where((comp) => comp.isNotEmpty).map(
              (comp) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 14)),
                    Expanded(child: Text(comp, style: const TextStyle(fontSize: 14, height: 1.5))),
                  ],
                ),
              ),
            ),
      ],
    );
  }

  // ----------------------------
  // Format Date
  // ----------------------------
  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

  // ----------------------------
  // Postuler Dialog
  // ----------------------------
void _showPostulerDialog(
  BuildContext context,
  CondidatureEntity c,
  WidgetRef ref,
  String internshipId, // <-- pass it here
) async {
  print('🔍 DEBUG _showPostulerDialog:');
  print('   - Condidature ID: ${c.id}');
  print('   - internshipId: $internshipId'); // now it's correct
  print('   - Condidature department: ${c.department}');

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Postuler'),
      content: Text('Voulez-vous postuler pour le stage ${c.department}?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(context);
            final user = FirebaseAuth.instance.currentUser;
            if (user == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Veuillez vous connecter'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            try {
              final application = ApplicationEntity(
                id: '',
                studentId: user.uid,
                internshipId: internshipId, // use the parameter
                status: CondidatureStatus.pending,
                appliedAt: DateTime.now(),
              );

              await ref.read(addApplicationProvider(application));

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Candidature envoyée pour ${c.department}'),
                  backgroundColor: Colors.green,
                ),
              );
            } catch (e) {
              print('❌ Error creating application: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
              );
            }
          },
          child: const Text('Postuler'),
        ),
      ],
    ),
  );
}

}
