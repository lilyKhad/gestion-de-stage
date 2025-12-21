import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:med/core/enums/statuts.dart';
import 'package:med/core/routers/router.dart';
import 'package:med/features/%C3%89tablissements/presentation/create_internship.dart';
import 'package:med/features/%C3%89tablissements/provider/hospital_provider.dart';
import 'package:med/features/Internship/presentation/InternshipDetailsScreen.dart';

// --- 1. THEME DESIGN SYSTEM ---
class AppTheme {
  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color primaryLight = Color(0xFFEFF6FF);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color sidebarBorder = Color(0xFFE2E8F0);

  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);

  static BoxShadow softShadow = BoxShadow(
    color: const Color(0xFF64748B).withOpacity(0.08),
    blurRadius: 24,
    offset: const Offset(0, 8),
  );
}

class HospitalDashboard extends ConsumerStatefulWidget {
  const HospitalDashboard({super.key});

  @override
  ConsumerState<HospitalDashboard> createState() => _HospitalDashboardState();
}

class _HospitalDashboardState extends ConsumerState<HospitalDashboard> {
  int _selectedIndex = 0; 

  Future<void> _signOut() async {
    try {
      ref.invalidate(currentHospitalStreamProvider);
      ref.invalidate(hospitalInternshipsProvider);
      ref.invalidate(hospitalApplicationsCountProvider);
      await FirebaseAuth.instance.signOut();
      if (mounted) ref.read(goRouterProvider).go('/');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur : $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hospitalAsync = ref.watch(currentHospitalStreamProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: hospitalAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primaryBlue)),
        error: (err, stack) => Center(child: Text("Erreur: $err")),
        data: (hospital) {
          if (hospital == null) return const Center(child: Text("Profil introuvable."));

          final hospitalName = hospital.name;
          
          final internshipsAsync = ref.watch(hospitalInternshipsProvider(hospitalName));
          final appsCountAsync = ref.watch(hospitalApplicationsCountProvider(hospitalName));

          return Row(
            children: [
              // -------------------------
              // 1. SIDEBAR BLANCHE (Modifiée)
              // -------------------------
              Container(
                width: 280,
                decoration: const BoxDecoration(
                  color: AppTheme.surface,
                  border: Border(right: BorderSide(color: AppTheme.sidebarBorder)),
                ),
                child: Column(
                  children: [
                    // LOGO AREA
                    Container(
                      height: 90,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 30),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: AppTheme.primaryBlue, borderRadius: BorderRadius.circular(8)),
                            child: const Icon(Icons.local_hospital_rounded, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Text("MED HOSPITAL", style: GoogleFonts.poppins(color: AppTheme.textDark, fontWeight: FontWeight.bold, fontSize: 18)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // MENU ITEMS (Ajout des listes Médecins et Étudiants)
                    _buildSidebarItem(0, Icons.dashboard_rounded, "Tableau de bord"),
                    
                    
                    // NOUVEAUX ITEMS DEMANDÉS
                    _buildSidebarItem(2, Icons.medical_services_outlined, "Liste des Médecins"),
                    _buildSidebarItem(3, Icons.school_outlined, "Liste des Étudiants"),
                    
                    _buildSidebarItem(4, Icons.settings_outlined, "Paramètres"),

                    const Spacer(),
                    
                    // BOUTON DÉCONNEXION
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: InkWell(
                        onTap: _signOut,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEE2E2), 
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.logout_rounded, color: Color(0xFF991B1B), size: 20),
                              const SizedBox(width: 12),
                              Text("Déconnexion", style: GoogleFonts.inter(color: const Color(0xFF991B1B), fontWeight: FontWeight.w600, fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              // -------------------------
              // 2. CONTENU PRINCIPAL
              // -------------------------
              Expanded(
                child: Column(
                  children: [
                    _buildHeader(hospitalName),

                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // HEADER SECTION
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Tableau de bord", style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                                    const SizedBox(height: 4),
                                    Text("Gérez vos offres et candidatures", style: GoogleFonts.inter(color: AppTheme.textGrey, fontSize: 14)),
                                  ],
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => CreateInternshipScreen(hospitalName: hospitalName)));
                                  },
                                  icon: const Icon(Icons.add, size: 20),
                                  label: Text("Créer une Offre", style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryBlue,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 32),

                            // KPI CARDS
                            internshipsAsync.when(
                              loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
                              error: (e, s) => const SizedBox(),
                              data: (internships) {
                                final int uniqueServices = internships.map((i) => i.department).toSet().length;
                                return Row(
                                  children: [
                                    _buildStatCard("Services Actifs", uniqueServices.toString(), Colors.purple, Icons.domain_rounded),
                                    const SizedBox(width: 24),
                                    _buildStatCard("Stages Publiés", internships.length.toString(), AppTheme.primaryBlue, Icons.work_outline_rounded),
                                    const SizedBox(width: 24),
                                    _buildStatCard("Total Demandes", appsCountAsync.value?.toString() ?? "0", Colors.orange, Icons.people_outline_rounded),
                                  ],
                                );
                              },
                            ),

                            const SizedBox(height: 40),

                            // TABLE SECTION (LARGEUR AUGMENTÉE)
                            Container(
                              width: double.infinity, // <--- PREND TOUTE LA LARGEUR
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: AppTheme.surface,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [AppTheme.softShadow],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Offres de Stages Récentes", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
                                  const SizedBox(height: 24),
                                  
                                  internshipsAsync.when(
                                    loading: () => const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),
                                    error: (e, s) => Text("Erreur: $e"),
                                    data: (internships) {
                                      if (internships.isEmpty) return const Center(child: Padding(padding: EdgeInsets.all(20), child: Text("Aucune offre publiée.")));

                                      return Theme(
                                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                        child: SizedBox(
                                          width: double.infinity, // S'assure que le DataTable prend toute la place
                                          child: DataTable(
                                            headingRowColor: WidgetStateProperty.all(AppTheme.background),
                                            headingTextStyle: GoogleFonts.inter(color: AppTheme.textLight, fontWeight: FontWeight.bold, fontSize: 12),
                                            dataRowHeight: 70,
                                            columnSpacing: 40, // <--- ESPACEMENT AUGMENTÉ POUR ÉLARGIR
                                            columns: const [
                                              DataColumn(label: Text("SERVICE")),
                                              DataColumn(label: Text("ENCADRANT")),
                                              DataColumn(label: Text("DÉBUT")),
                                              DataColumn(label: Text("STATUT")),
                                              DataColumn(label: Text("ACTIONS")),
                                            ],
                                            rows: internships.map((internship) {
                                              final formattedDate = DateFormat('dd MMM yyyy', 'fr_FR').format(internship.startDate);
                                              return DataRow(
                                                cells: [
                                                  DataCell(
                                                    Row(children: [
                                                      Container(
                                                        padding: const EdgeInsets.all(8),
                                                        decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                                                        child: const Icon(Icons.medical_services_outlined, color: AppTheme.primaryBlue, size: 18),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Text(internship.department, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppTheme.textDark)),
                                                    ]),
                                                  ),
                                                  DataCell(Text("Dr. ${internship.doctorName}", style: GoogleFonts.inter(color: AppTheme.textGrey))),
                                                  DataCell(Text(formattedDate, style: GoogleFonts.inter(color: AppTheme.textGrey))),
                                                  DataCell(_buildStatusBadge(internship.status)),
                                                  DataCell(
                                                    Row(
                                                      children: [
                                                        IconButton(
                                                          icon: const Icon(Icons.visibility_outlined, color: AppTheme.textGrey, size: 20),
                                                          onPressed: () {
                                                            Navigator.push(context, MaterialPageRoute(builder: (_) => CondidatureDetailScreen(internshipId: internship.id)));
                                                          },
                                                        ),
                                                        IconButton(
                                                          icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444), size: 20),
                                                          onPressed: () => _showDeleteDialog(context, internship.id),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- WIDGETS DE DESIGN ---

  Widget _buildHeader(String hospitalName) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(bottom: BorderSide(color: AppTheme.sidebarBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: AppTheme.background, shape: BoxShape.circle),
            child: const Icon(Icons.notifications_none_rounded, color: AppTheme.textGrey),
          ),
          const SizedBox(width: 20),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.primaryLight,
                child: Text(hospitalName.isNotEmpty ? hospitalName[0] : "H", style: const TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Text(hospitalName, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppTheme.textDark)),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppTheme.textGrey)
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSidebarItem(int index, IconData icon, String title) {
    bool isSelected = _selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _selectedIndex = index),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryLight : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(icon, color: isSelected ? AppTheme.primaryBlue : AppTheme.textGrey, size: 22),
                const SizedBox(width: 14),
                // Expanded pour éviter l'overflow si le texte est long
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      color: isSelected ? AppTheme.primaryBlue : AppTheme.textGrey,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [AppTheme.softShadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: Icon(icon, color: color, size: 24),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(value, style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
            const SizedBox(height: 4),
            Text(title, style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textGrey)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(InternshipStatus status) {
    Color bg;
    Color text;
    String label;

    switch (status) {
      case InternshipStatus.pending:
        bg = const Color(0xFFFEF3C7); 
        text = const Color(0xFFD97706); 
        label = "EN ATTENTE";
        break;
      default:
        bg = const Color(0xFFDBEAFE); 
        text = const Color(0xFF1D4ED8); 
        label = status.name.toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(color: text, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String internshipId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Supprimer l'offre", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        content: Text("Êtes-vous sûr de vouloir supprimer cette offre ?", style: GoogleFonts.inter(color: AppTheme.textGrey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Annuler", style: GoogleFonts.inter(color: AppTheme.textGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            onPressed: () async {
              await FirebaseFirestore.instance.collection('internships').doc(internshipId).delete();
              if (context.mounted) Navigator.pop(context);
            },
            child: Text("Supprimer", style: GoogleFonts.inter(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}