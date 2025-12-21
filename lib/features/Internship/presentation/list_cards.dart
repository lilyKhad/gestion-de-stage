import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med/features/Internship/presentation/card.dart';
import 'package:med/features/Internship/providers/ineternship_provider.dart';
import 'package:med/features/etudiant/presentation/widgets/sidebar_wrapper.dart';

class InternshipListScreen extends ConsumerWidget {
  const InternshipListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SidebarWrapper(
      builder: (context, ref, selectedIndex) {
        return _buildContent(context, ref);
      },
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    String searchQuery = '';

    return StatefulBuilder(
      builder: (context, setState) {
        final filteredInternshipsAsync =
            ref.watch(searchInternshipsProvider(searchQuery));

        return Scaffold(
          backgroundColor:
              const Color(0xFFF8FAFC), // Couleur cohérente avec sidebar
          body: Column(
            children: [
              // --- Search Header ---
              Container(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      const Color(0xFFF0F7FF),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2563EB).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.work_outline,
                            color: Color(0xFF2563EB),
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Offres de Stages',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Découvrez les opportunités de stage disponibles',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (value) =>
                            setState(() => searchQuery = value),
                        decoration: InputDecoration(
                          hintText:
                              'Rechercher par service, docteur, hôpital...',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 15,
                          ),
                          prefixIcon: Container(
                            margin: const EdgeInsets.only(left: 4),
                            child: const Icon(
                              Icons.search_rounded,
                              color: Color(0xFF2563EB),
                              size: 24,
                            ),
                          ),
                          suffixIcon: searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.grey.shade500,
                                    size: 20,
                                  ),
                                  onPressed: () =>
                                      setState(() => searchQuery = ''),
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Colors.grey.shade200,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFF2563EB),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Statistiques rapides
                    const SizedBox(height: 25),
                    _buildStatistics(filteredInternshipsAsync),
                  ],
                ),
              ),

              // --- List Body ---
              Expanded(
                child: filteredInternshipsAsync.when(
                  loading: () => _buildLoadingState(),
                  error: (error, _) => _buildErrorState(error),
                  data: (internships) {
                    if (internships.isEmpty) {
                      return _buildEmptyState(searchQuery);
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Column(
                        children: [
                          // En-tête de la liste
                          Row(
                            children: [
                              Text(
                                '${internships.length} ${internships.length > 1 ? 'stages trouvés' : 'stage trouvé'}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.filter_alt_outlined,
                                  color: Colors.grey.shade600,
                                ),
                                tooltip: 'Filtrer',
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Liste des stages
                          Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.only(bottom: 24),
                              itemCount: internships.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                return InternshipCard(
                                  internship: internships[index],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatistics(AsyncValue<List<dynamic>> internshipsAsync) {
    return internshipsAsync.when(
      data: (internships) {
        final total = internships.length;

        return Row(
          children: [
            _buildStatItem(
              icon: Icons.library_books_outlined,
              value: total.toString(),
              label: 'Total',
              color: const Color(0xFF2563EB),
            ),
            const SizedBox(width: 16),
            _buildStatItem(
              icon: Icons.location_on_outlined,
              value: _countUniqueHospitals(internships).toString(),
              label: 'Hôpitaux',
              color: const Color(0xFF10B981),
            ),
            const SizedBox(width: 16),
            _buildStatItem(
              icon: Icons.medical_services_outlined,
              value: _countUniqueDepartments(internships).toString(),
              label: 'Services',
              color: const Color(0xFF8B5CF6),
            ),
          ],
        );
      },
      loading: () => Row(
        children: [
          _buildStatItemLoading(),
          const SizedBox(width: 16),
          _buildStatItemLoading(),
          const SizedBox(width: 16),
          _buildStatItemLoading(),
        ],
      ),
      error: (_, __) => Container(),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const Spacer(),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItemLoading() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(radius: 12, backgroundColor: Colors.grey),
                const Spacer(),
                SizedBox(
                  width: 30,
                  height: 20,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.grey.shade200,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 50,
              height: 10,
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey.shade200,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                const Color(0xFF2563EB).withOpacity(0.7),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Chargement des offres...',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Recherche des meilleures opportunités',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(dynamic error) {
    return Center(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFCA5A5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 48,
                color: Color(0xFFDC2626),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Oups ! Une erreur est survenue',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFDC2626),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Erreur: $error',
              style: const TextStyle(
                color: Color(0xFFDC2626),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh, size: 20),
              label: const Text(
                'Réessayer',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String searchQuery) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.work_outline,
                size: 64,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              searchQuery.isEmpty
                  ? "Aucune offre de stage disponible"
                  : "Aucun résultat pour '$searchQuery'",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              searchQuery.isEmpty
                  ? "Revenez plus tard pour découvrir de nouvelles opportunités"
                  : "Essayez avec d'autres mots-clés",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (searchQuery.isNotEmpty)
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2563EB),
                  side: const BorderSide(color: Color(0xFF2563EB)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Effacer la recherche'),
              ),
          ],
        ),
      ),
    );
  }

  int _countUniqueHospitals(List<dynamic> internships) {
    final hospitals = <String>{};
    for (var internship in internships) {
      if (internship.hospital != null) {
        hospitals.add(internship.hospital);
      }
    }
    return hospitals.length;
  }

  int _countUniqueDepartments(List<dynamic> internships) {
    final departments = <String>{};
    for (var internship in internships) {
      if (internship.department != null) {
        departments.add(internship.department);
      }
    }
    return departments.length;
  }
}
