import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:med/features/doyen/provider/admin_providers.dart';
import 'package:google_fonts/google_fonts.dart'; // Assurez-vous d'avoir google_fonts dans pubspec.yaml

// --- 1. PALETTE DE COULEURS "MEDSTAGE" (MODERNE & LUMINEUX) ---
class AppTheme {
  // Couleurs Principales
  static const Color primaryBlue = Color(0xFF3B82F6);    // Bleu Royal moderne
  static const Color primaryLight = Color(0xFFEFF6FF);   // Bleu très pâle (Fond actif)
  static const Color background = Color(0xFFF8FAFC);     // Gris bleuté très pâle (Fond page)
  static const Color surface = Colors.white;             // Blanc pur

  // Textes
  static const Color textDark = Color(0xFF1E293B);       // Gris foncé (Titres)
  static const Color textGrey = Color(0xFF64748B);       // Gris moyen (Sous-titres)
  static const Color textLight = Color(0xFF94A3B8);      // Gris clair (Labels)

  // Status (Pastel)
  static const Color successBg = Color(0xFFDCFCE7);      // Vert pastel
  static const Color successText = Color(0xFF166534);    // Vert fort
  static const Color warningBg = Color(0xFFFEF3C7);      // Jaune pastel
  static const Color warningText = Color(0xFFD97706);    // Orange fort
  static const Color errorBg = Color(0xFFFEE2E2);        // Rouge pastel
  static const Color errorText = Color(0xFF991B1B);      // Rouge fort

  // Ombres "Glass" douces
  static BoxShadow softShadow = BoxShadow(
    color: const Color(0xFF64748B).withOpacity(0.08), // Ombre très légère
    blurRadius: 24,
    offset: const Offset(0, 8),
  );
}

class DeanDashboardScreen extends ConsumerStatefulWidget {
  const DeanDashboardScreen({super.key});

  @override
  ConsumerState<DeanDashboardScreen> createState() => _DeanDashboardScreenState();
}

class _DeanDashboardScreenState extends ConsumerState<DeanDashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final deanAsync = ref.watch(currentDeanStreamProvider);
    final deanName = deanAsync.value?.name ?? "Monsieur le Doyen";

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Row(
        children: [
          // -----------------------
          // 1. SIDEBAR BLANCHE (Style MedStage)
          // -----------------------
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: AppTheme.surface,
              border: Border(right: BorderSide(color: Colors.grey.shade100)),
            ),
            child: _ModernSidebar(
              currentIndex: _selectedIndex,
              onIndexChanged: (index) => setState(() => _selectedIndex = index),
            ),
          ),

          // -----------------------
          // 2. CONTENU PRINCIPAL
          // -----------------------
          Expanded(
            child: Column(
              children: [
                // Header Blanc Minimaliste
                _buildModernHeader(deanName),
                
                // Contenu
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32.0),
                    child: _buildPageContent(_selectedIndex),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Header style "Clean"
  Widget _buildModernHeader(String name) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Tableau de bord", style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
              Text("Vue d'ensemble de la faculté", style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textGrey)),
            ],
          ),
          Row(
            children: [
              // Bouton notif rond
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.background, 
                  shape: BoxShape.circle
                ),
                child: const Icon(Icons.notifications_none_rounded, color: AppTheme.textGrey),
              ),
              const SizedBox(width: 20),
              // Profil
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppTheme.primaryLight,
                    child: Text(name.isNotEmpty ? name[0].toUpperCase() : "D", style: const TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  Text(name, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppTheme.textDark)),
                  const SizedBox(width: 5),
                  const Icon(Icons.keyboard_arrow_down, size: 18, color: AppTheme.textGrey),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(int index) {
    switch (index) {
      case 0:
        return const _DashboardHomeTab();
      default:
        return Center(child: Text("Page en construction", style: GoogleFonts.inter(color: AppTheme.textGrey)));
    }
  }
}

// ---------------------------------------------------------------------------
// 1. SIDEBAR WIDGET (Fond Blanc & Items Bleus)
// ---------------------------------------------------------------------------
class _ModernSidebar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onIndexChanged;

  const _ModernSidebar({required this.currentIndex, required this.onIndexChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // LOGO AREA
        Container(
          height: 90,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 30),
          child: Row(
            children: [
              // Logo placeholder icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppTheme.primaryBlue, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.health_and_safety, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text("MED ADMIN", style: GoogleFonts.poppins(color: AppTheme.textDark, fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        
        // MENU
        _buildSectionTitle("MENU PRINCIPAL"),
        _buildMenuItem(0, Icons.grid_view_rounded, "Vue d'ensemble"),
        _buildMenuItem(1, Icons.people_outline_rounded, "Étudiants"),
        _buildMenuItem(2, Icons.local_hospital_outlined, "Hôpitaux"),
        
        const SizedBox(height: 20),
        _buildSectionTitle("SYSTÈME"),
        _buildMenuItem(3, Icons.settings_outlined, "Paramètres"),
        
        const Spacer(),
        
        // LOGOUT
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: InkWell(
            onTap: () async {
               await FirebaseAuth.instance.signOut();
               if(context.mounted) context.go('/');
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: AppTheme.errorBg.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                 
                  const Icon(Icons.logout, color: AppTheme.errorText, size: 20),
                  const SizedBox(width: 12),
                  Text("Déconnexion", style: GoogleFonts.inter(color: AppTheme.errorText, fontWeight: FontWeight.w600, fontSize: 14)),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 16, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title, 
          style: GoogleFonts.inter(color: AppTheme.textLight, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)
        ),
      ),
    );
  }

  Widget _buildMenuItem(int index, IconData icon, String title) {
    final bool isActive = currentIndex == index;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onIndexChanged(index),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              // STYLE ACTIF : Fond Bleu très pâle
              color: isActive ? AppTheme.primaryLight : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                // STYLE ICONE : Bleu si actif, Gris si inactif
                Icon(icon, color: isActive ? AppTheme.primaryBlue : AppTheme.textGrey, size: 22),
                const SizedBox(width: 14),
                // STYLE TEXTE : Bleu/Gras si actif
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: isActive ? AppTheme.primaryBlue : AppTheme.textGrey,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. DASHBOARD CONTENT (CONTENU PRINCIPAL)
// ---------------------------------------------------------------------------
class _DashboardHomeTab extends ConsumerWidget {
  const _DashboardHomeTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Récupération des données via Riverpod
    final studentsAsync = ref.watch(allStudentsProvider);
    final hospitalsAsync = ref.watch(allHospitalsProvider);
    final applicationsAsync = ref.watch(acceptedApplicationsProvider);
    final internshipsAsync = ref.watch(allInternshipsProvider);

    // Loading State
    if (studentsAsync.isLoading || hospitalsAsync.isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppTheme.primaryBlue));
    }

    // Calculs des données
    final totalStudents = studentsAsync.value?.length ?? 0;
    final totalHospitals = hospitalsAsync.value?.length ?? 0;
    
    final studentsWithStageIds = applicationsAsync.value?.map((doc) => doc['studentId']).toSet() ?? {};
    final countWithStage = studentsWithStageIds.length;
    final countWithoutStage = (totalStudents - countWithStage).clamp(0, totalStudents);

    final hospitals = hospitalsAsync.value ?? [];
    final internships = internshipsAsync.value ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Statistiques Rapides", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
        const SizedBox(height: 20),
        
        // --- 1. CARTES KPI ---
        Row(
          children: [
            _KpiCard(
              title: "Total Étudiants", 
              value: totalStudents.toString(), 
              icon: Icons.school_outlined, 
              color: AppTheme.primaryBlue,
              bgColor: AppTheme.primaryLight
            ),
            const SizedBox(width: 24),
            _KpiCard(
              title: "Hôpitaux", 
              value: totalHospitals.toString(), 
              icon: Icons.local_hospital_outlined, 
              color: Colors.purple,
              bgColor: Colors.purple.shade50
            ),
            const SizedBox(width: 24),
            _KpiCard(
              title: "Étudiants en Stage", 
              value: countWithStage.toString(), 
              icon: Icons.task_alt, 
              color: AppTheme.successText,
              bgColor: AppTheme.successBg
            ),
            const SizedBox(width: 24),
            _KpiCard(
              title: "En Attente", 
              value: countWithoutStage.toString(), 
              icon: Icons.pending_actions, 
              color: AppTheme.warningText,
              bgColor: AppTheme.warningBg
            ),
          ],
        ),

        const SizedBox(height: 32),

        // --- 2. GRAPHIQUES & LISTES ---
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Graphique (Donut)
            Expanded(
              flex: 4,
              child: _SectionContainer(
                title: "Répartition des Stages",
                child: _DonutChart(withStage: countWithStage, withoutStage: countWithoutStage),
              ),
            ),
            const SizedBox(width: 24),
            // Liste Hôpitaux
            Expanded(
              flex: 6,
              child: _SectionContainer(
                title: "Top Établissements",
                child: _HospitalList(hospitals: hospitals, internships: internships),
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // --- 3. TABLEAU DÉTAILLÉ ---
        _SectionContainer(
          title: "État des Services Hospitaliers",
          padding: 0, // Pas de padding pour coller le header du tableau aux bords
          child: _ModernTable(hospitals: hospitals, internships: internships),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 3. WIDGETS ESTHÉTIQUES (HELPERS)
// ---------------------------------------------------------------------------

// Carte KPI Style "Glass/Flat"
class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color bgColor;

  const _KpiCard({
    required this.title, 
    required this.value, 
    required this.icon, 
    required this.color,
    required this.bgColor
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [AppTheme.softShadow], // Ombre douce
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icone dans un cercle coloré
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
                  child: Icon(icon, color: color, size: 22),
                ),
                // Petit indicateur de hausse (fake data pour l'esthétique)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: AppTheme.successBg, borderRadius: BorderRadius.circular(4)),
                  child: Row(
                    children: const [
                      Icon(Icons.arrow_upward, size: 10, color: AppTheme.successText),
                      SizedBox(width: 2),
                      Text("2.5%", style: TextStyle(fontSize: 10, color: AppTheme.successText, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Text(value, style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
            const SizedBox(height: 5),
            Text(title, style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textGrey)),
          ],
        ),
      ),
    );
  }
}

// Conteneur blanc standard
class _SectionContainer extends StatelessWidget {
  final String title;
  final Widget child;
  final double padding;

  const _SectionContainer({required this.title, required this.child, this.padding = 24});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppTheme.softShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(padding == 0) Padding(
            padding: const EdgeInsets.all(24),
            child: Text(title, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
          ) else Text(title, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
          
          if(padding != 0) const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}

// Graphique Donut Clean
class _DonutChart extends StatelessWidget {
  final int withStage;
  final int withoutStage;

  const _DonutChart({required this.withStage, required this.withoutStage});

  @override
  Widget build(BuildContext context) {
    if (withStage == 0 && withoutStage == 0) return const SizedBox(height: 200, child: Center(child: Text("Aucune donnée")));
    
    return Row(
      children: [
        SizedBox(
          height: 180,
          width: 180,
          child: PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 65,
              sections: [
                PieChartSectionData(
                  color: AppTheme.primaryBlue, 
                  value: withStage.toDouble(), 
                  title: '', 
                  radius: 20
                ),
                PieChartSectionData(
                  color: Colors.grey.shade100, 
                  value: withoutStage.toDouble(), 
                  title: '', 
                  radius: 20
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLegendItem(AppTheme.primaryBlue, "En Stage", withStage),
            const SizedBox(height: 12),
            _buildLegendItem(Colors.grey.shade300, "En Attente", withoutStage),
          ],
        )
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label, int count) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: GoogleFonts.inter(color: AppTheme.textGrey, fontSize: 12)),
            Text(count.toString(), style: GoogleFonts.inter(color: AppTheme.textDark, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        )
      ],
    );
  }
}

// Liste simple Hôpitaux
class _HospitalList extends StatelessWidget {
  final List<dynamic> hospitals;
  final List<dynamic> internships;

  const _HospitalList({required this.hospitals, required this.internships});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: hospitals.take(4).length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final hospital = hospitals[index];
        final name = hospital['name'] ?? 'Inconnu';
        final count = internships.where((i) => i.hospital == name).length;

        return Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppTheme.background, borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.local_hospital_rounded, color: AppTheme.primaryBlue, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppTheme.textDark)),
                  Text("Service Hospitalier", style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textGrey)),
                ],
              ),
            ),
            Text("$count offres", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppTheme.textDark)),
          ],
        );
      },
    );
  }
}

// Tableau "Table" Design sans lignes
class _ModernTable extends StatelessWidget {
  final List<dynamic> hospitals;
  final List<dynamic> internships;

  const _ModernTable({required this.hospitals, required this.internships});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent), // Enlever les lignes
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(AppTheme.background), // Header gris clair
          horizontalMargin: 24,
          columnSpacing: 20,
          headingTextStyle: GoogleFonts.inter(color: AppTheme.textLight, fontWeight: FontWeight.bold, fontSize: 12),
          dataRowHeight: 70,
          columns: const [
            DataColumn(label: Text('ÉTABLISSEMENT')),
            DataColumn(label: Text('OFFRES')),
            DataColumn(label: Text('TAUX OCCUPATION')),
            DataColumn(label: Text('STATUS')),
          ],
          rows: hospitals.take(5).map((h) {
            final name = h['name'] ?? 'Inconnu';
            final offers = internships.where((i) => i.hospital == name).length;
            final bool isFull = offers == 0; // Logique simple pour l'exemple
            
            return DataRow(
              cells: [
                DataCell(
                  Row(
                    children: [
                      CircleAvatar(radius: 16, backgroundColor: Colors.grey.shade200, child: Text(name[0], style: GoogleFonts.inter(fontSize: 12, color: Colors.black))),
                      const SizedBox(width: 12),
                      Text(name, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppTheme.textDark)),
                    ],
                  )
                ),
                DataCell(Text("$offers postes", style: GoogleFonts.inter(color: AppTheme.textGrey))),
                DataCell(
                  // Barre de progression fake
                  SizedBox(
                    width: 100,
                    child: LinearProgressIndicator(
                      value: isFull ? 1.0 : 0.6, 
                      backgroundColor: Colors.grey.shade100,
                      color: isFull ? AppTheme.errorText : AppTheme.primaryBlue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  )
                ),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isFull ? AppTheme.errorBg : AppTheme.successBg,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text(
                      isFull ? "Complet" : "Disponible",
                      style: GoogleFonts.inter(
                        color: isFull ? AppTheme.errorText : AppTheme.successText,
                        fontSize: 11, fontWeight: FontWeight.bold
                      ),
                    ),
                  )
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}