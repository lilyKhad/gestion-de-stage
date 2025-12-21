import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // Assurez-vous d'avoir ceci pour la navigation
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:med/core/enums/statuts.dart';
import 'package:med/features/%C3%89tablissements/provider/hospital_provider.dart';
import 'package:med/features/Internship/domain/entity/internship.dart';

// --- 1. THEME (Identique au Dashboard) ---
class AppTheme {
  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color primaryLight = Color(0xFFEFF6FF);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);
  static const Color sidebarBorder = Color(0xFFE2E8F0);
  static const Color borderColor = Color(0xFFE2E8F0);
   static BoxShadow softShadow = BoxShadow(
    color: const Color(0xFF64748B).withOpacity(0.08),
    blurRadius: 24,
    offset: const Offset(0, 8),
  );
  
  static InputDecoration inputDecoration(String hint, {Widget? prefixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 13),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      prefixIcon: prefixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primaryBlue, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }
}

class CreateInternshipScreen extends ConsumerStatefulWidget {
  final String hospitalName; 
  const CreateInternshipScreen({super.key, required this.hospitalName});

  @override
  ConsumerState<CreateInternshipScreen> createState() => _CreateInternshipScreenState();
}

class _CreateInternshipScreenState extends ConsumerState<CreateInternshipScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  int _sidebarIndex = 1; // On simule qu'on est dans la section "Mes Offres"

  // Controllers
  final _departmentCtrl = TextEditingController();
  final _durationCtrl = TextEditingController();
  final _niveauStageCtrl = TextEditingController();
  final _notesCtrl = TextEditingController(); // Ajouté comme demandé précédemment

  DateTime _startDate = DateTime.now();
  String? _selectedDoctorId;
  String? _selectedDoctorName;

  final List<TextEditingController> _objectifsCtrls = [TextEditingController()];
  final List<TextEditingController> _competencesCtrls = [TextEditingController()];

  @override
  void dispose() {
    _departmentCtrl.dispose();
    _durationCtrl.dispose();
    _niveauStageCtrl.dispose();
    _notesCtrl.dispose();
    for (var c in _objectifsCtrls) c.dispose();
    for (var c in _competencesCtrls) c.dispose();
    super.dispose();
  }

  void _addObjective() => setState(() => _objectifsCtrls.add(TextEditingController()));
  void _addCompetence() => setState(() => _competencesCtrls.add(TextEditingController()));

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedDoctorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Médecin requis"), backgroundColor: Colors.orange));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final String uniqueId = const Uuid().v4();

      final newInternship = Internship(
        id: uniqueId,
        department: _departmentCtrl.text.trim(),
        doctorId: _selectedDoctorId!,
        doctorName: _selectedDoctorName ?? "Inconnu",
        hospital: widget.hospitalName,
        startDate: _startDate,
        duree: _durationCtrl.text.trim(),
        notes: _notesCtrl.text.trim().isEmpty ? "Aucune note." : _notesCtrl.text.trim(),
        niveauStage: _niveauStageCtrl.text.trim(),
        objectifs: _objectifsCtrls.map((c) => c.text.trim()).where((t) => t.isNotEmpty).toList(),
        competences: _competencesCtrls.map((c) => c.text.trim()).where((t) => t.isNotEmpty).toList(),
        status: InternshipStatus.pending, 
      );

      await FirebaseFirestore.instance.collection('internships').doc(uniqueId).set(newInternship.toMap());
      await FirebaseFirestore.instance.collection('users').doc(_selectedDoctorId).update({'internshipIds': FieldValue.arrayUnion([uniqueId])});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Offre publiée !"), backgroundColor: Colors.green));
        Navigator.pop(context); // Retour au dashboard après succès
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur: $e"), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- WIDGETS DE NAVIGATION (Sidebar & Header) ---

  Widget _buildSidebar() {
    return Container(
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
          
          // ITEMS
          _buildSidebarItem(0, Icons.dashboard_rounded, "Tableau de bord", onTap: () => Navigator.pop(context)),
          _buildSidebarItem(1, Icons.list_alt_rounded, "Mes Offres (Création)"), // Actif
          _buildSidebarItem(2, Icons.medical_services_outlined, "Liste des Médecins"),
          _buildSidebarItem(3, Icons.school_outlined, "Liste des Étudiants"),
          _buildSidebarItem(4, Icons.settings_outlined, "Paramètres"),
          
          const Spacer(),
          // Logout visual only
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const Icon(Icons.logout_rounded, color: Color(0xFF991B1B), size: 20),
                  const SizedBox(width: 12),
                  Text("Déconnexion", style: GoogleFonts.inter(color: const Color(0xFF991B1B), fontWeight: FontWeight.w600, fontSize: 14)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSidebarItem(int index, IconData icon, String title, {VoidCallback? onTap}) {
    bool isSelected = _sidebarIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
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
                Expanded(child: Text(title, style: GoogleFonts.inter(color: isSelected ? AppTheme.primaryBlue : AppTheme.textGrey, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500, fontSize: 14), overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(bottom: BorderSide(color: AppTheme.sidebarBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Petit bouton retour pour l'UX
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: AppTheme.textGrey),
            tooltip: "Retour au tableau de bord",
          ),
          
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(color: AppTheme.background, shape: BoxShape.circle),
                child: const Icon(Icons.notifications_none_rounded, color: AppTheme.textGrey),
              ),
              const SizedBox(width: 20),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: AppTheme.primaryLight,
                    child: Text("H", style: TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  Text(widget.hospitalName, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppTheme.textDark)),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppTheme.textGrey)
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  // --- STRUCTURE PRINCIPALE (Scaffold avec Row) ---

  @override
  Widget build(BuildContext context) {
    final doctorsAsync = ref.watch(hospitalDoctorsProvider(widget.hospitalName));

    return Scaffold(
      backgroundColor: AppTheme.background,
      // Pas d'AppBar ici, on le construit nous-même
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. SIDEBAR GAUCHE
          _buildSidebar(),

          // 2. CONTENU DROITE
          Expanded(
            child: Column(
              children: [
                // Header (Appbar personnalisée)
                _buildHeader(),
                
                // Formulaire scrollable
                Expanded(
                  child: _isLoading 
                    ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryBlue))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(32),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Titre de la page
                              Text("Créer une nouvelle offre", style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                              const SizedBox(height: 5),
                              Text("Remplissez les informations ci-dessous pour publier un stage.", style: GoogleFonts.inter(color: AppTheme.textGrey, fontSize: 14)),
                              const SizedBox(height: 32),

                              // --- DEBUT DU FORMULAIRE EXISTANT ---
                              _buildSectionTitle("Informations Générales"),
                              const SizedBox(height: 16),
                              
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: AppTheme.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [],
                                ),
                                child: Column(
                                  children: [
                                    _buildLabel("Service Hospitalier"),
                                    TextFormField(
                                      controller: _departmentCtrl,
                                      decoration: AppTheme.inputDecoration("ex: Cardiologie, Pédiatrie...", prefixIcon: const Icon(Icons.domain, color: AppTheme.textGrey, size: 20)),
                                      validator: (v) => v!.isEmpty ? "Requis" : null,
                                    ),
                                    const SizedBox(height: 20),

                                    _buildLabel("Médecin Encadrant"),
                                    doctorsAsync.when(
                                      loading: () => const LinearProgressIndicator(color: AppTheme.primaryBlue),
                                      error: (err, stack) => Text("Erreur", style: GoogleFonts.inter(color: Colors.red)),
                                      data: (doctors) {
                                        return DropdownButtonFormField<String>(
                                          decoration: AppTheme.inputDecoration("Sélectionnez un médecin", prefixIcon: const Icon(Icons.person_outline, color: AppTheme.textGrey, size: 20)),
                                          dropdownColor: Colors.white,
                                          value: _selectedDoctorId,
                                          items: doctors.map((doc) {
                                            final name = doc['nom'] ?? doc['email'] ?? 'Inconnu';
                                            return DropdownMenuItem<String>(
                                              value: doc['uid'],
                                              child: Text("Dr. $name", style: GoogleFonts.inter(color: AppTheme.textDark)),
                                              onTap: () => _selectedDoctorName = "Dr. $name",
                                            );
                                          }).toList(),
                                          onChanged: (val) => setState(() => _selectedDoctorId = val),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 20),

                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _buildLabel("Durée"),
                                              TextFormField(
                                                controller: _durationCtrl,
                                                decoration: AppTheme.inputDecoration("ex: 30 jours", prefixIcon: const Icon(Icons.timer_outlined, color: AppTheme.textGrey, size: 20)),
                                                validator: (v) => v!.isEmpty ? "Requis" : null,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _buildLabel("Date de début"),
                                              InkWell(
                                                onTap: () async {
                                                  final d = await showDatePicker(
                                                    context: context, 
                                                    initialDate: DateTime.now(), 
                                                    firstDate: DateTime.now(), 
                                                    lastDate: DateTime(2030),
                                                    builder: (context, child) => Theme(data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: AppTheme.primaryBlue)), child: child!)
                                                  );
                                                  if(d != null) setState(() => _startDate = d);
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: AppTheme.borderColor), borderRadius: BorderRadius.circular(10)),
                                                  child: Row(
                                                    children: [
                                                      const Icon(Icons.calendar_today_outlined, color: AppTheme.textGrey, size: 20),
                                                      const SizedBox(width: 10),
                                                      Text(DateFormat('dd/MM/yyyy').format(_startDate), style: GoogleFonts.inter(color: AppTheme.textDark)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    
                                    // NOTES AJOUTÉES
                                    _buildLabel("Description / Notes"),
                                    TextFormField(
                                      controller: _notesCtrl,
                                      maxLines: 3,
                                      decoration: AppTheme.inputDecoration("Détails supplémentaires...", prefixIcon: const Icon(Icons.description_outlined, color: AppTheme.textGrey, size: 20)),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 32),
                              _buildSectionTitle("Détails Pédagogiques"),
                              const SizedBox(height: 16),

                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: AppTheme.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [AppTheme.softShadow],
                                ),
                                child: Column(
                                  children: [
                                    _buildLabel("Niveau Requis"),
                                    TextFormField(
                                      controller: _niveauStageCtrl,
                                      decoration: AppTheme.inputDecoration("ex: Résident", prefixIcon: const Icon(Icons.school_outlined, color: AppTheme.textGrey, size: 20)),
                                    ),
                                    const SizedBox(height: 24),
                                    _buildDynamicListHeader("Objectifs", _addObjective),
                                    ..._objectifsCtrls.map((c) => Padding(padding: const EdgeInsets.only(bottom: 12), child: TextFormField(controller: c, decoration: AppTheme.inputDecoration("Objectif...")))),
                                    const SizedBox(height: 24),
                                    _buildDynamicListHeader("Compétences", _addCompetence),
                                    ..._competencesCtrls.map((c) => Padding(padding: const EdgeInsets.only(bottom: 12), child: TextFormField(controller: c, decoration: AppTheme.inputDecoration("Compétence...")))),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 40),
                              SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                  onPressed: _submitForm,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryBlue,
                                    foregroundColor: Colors.white,
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: Text("PUBLIER L'OFFRE", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                                ),
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPERS IDENTIQUES ---
  Widget _buildSectionTitle(String title) => Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textDark));
  Widget _buildLabel(String label) => Padding(padding: const EdgeInsets.only(bottom: 8.0, left: 4), child: Align(alignment: Alignment.centerLeft, child: Text(label.toUpperCase(), style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textGrey, letterSpacing: 1.0))));
  Widget _buildDynamicListHeader(String title, VoidCallback onAdd) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppTheme.textDark, fontSize: 15)),
          InkWell(
            onTap: onAdd,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: AppTheme.primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  const Icon(Icons.add_circle_outline, size: 16, color: AppTheme.primaryBlue),
                  const SizedBox(width: 6),
                  Text("Ajouter", style: GoogleFonts.inter(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}