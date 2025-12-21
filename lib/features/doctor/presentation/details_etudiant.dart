import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:med/core/enums/statuts.dart';
import 'dart:convert';
import 'dart:html' as html;

class StudentDetailsDialog extends ConsumerStatefulWidget {
  final String applicationId;
  final String studentId;
  final String studentName;

  const StudentDetailsDialog({
    super.key,
    required this.applicationId,
    required this.studentId,
    required this.studentName,
  });

  @override
  ConsumerState<StudentDetailsDialog> createState() =>
      _StudentDetailsDialogState();
}

class _StudentDetailsDialogState extends ConsumerState<StudentDetailsDialog> {
  bool _isLoading = true;
  Map<String, dynamic>? _studentData;
  Map<String, dynamic>? _applicationData;

  // CHEMIN STATIQUE VERS VOTRE IMAGE
  final String _staticProfileImagePath = 'assets/Apropos/etudiante.jpg';

  @override
  void initState() {
    super.initState();
    _fetchAllDetails();
  }

  Future<void> _fetchAllDetails() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final appDoc = await firestore
          .collection('applications')
          .doc(widget.applicationId)
          .get();
      final userDoc =
          await firestore.collection('users').doc(widget.studentId).get();

      if (mounted) {
        setState(() {
          _applicationData = appDoc.data();
          _studentData = userDoc.data();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateStatus(InternshipStatus status) async {
    try {
      setState(() => _isLoading = true);
      final batch = FirebaseFirestore.instance.batch();
      final applicationRef = FirebaseFirestore.instance
          .collection('applications')
          .doc(widget.applicationId);

      final internshipId = _applicationData?['internshipId'];
      if (internshipId != null) {
        final internshipRef = FirebaseFirestore.instance
            .collection('internships')
            .doc(internshipId);
        batch.update(internshipRef, {'status': status.name});
      }

      batch.update(applicationRef, {'status': status.name});
      await batch.commit();

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(status == InternshipStatus.accepted
                ? "✨ Candidature acceptée !"
                : "Candidature refusée"),
            backgroundColor: status == InternshipStatus.accepted
                ? Colors.teal.shade700
                : Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Note: On n'utilise plus profileImgUrl ici car on passe par l'asset statique

    final dateDemande = _applicationData?['appliedAt'] != null
        ? DateFormat('dd MMMM yyyy', 'fr_FR')
            .format((_applicationData!['appliedAt'] as Timestamp).toDate())
        : "Date inconnue";

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 600,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 30,
                offset: const Offset(0, 15)),
          ],
        ),
        child: _isLoading
            ? const SizedBox(
                height: 400,
                child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF2563EB))))
            : ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildModernHeader(), // Pas besoin de passer l'URL
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildStatusBanner(dateDemande),
                            const SizedBox(height: 30),
                            _buildSectionHeader(
                                Icons.school_rounded, "Parcours Académique"),
                            const SizedBox(height: 15),
                            _buildInfoGrid(),
                            const SizedBox(height: 35),
                            _buildSectionHeader(
                                Icons.description_rounded, "Pièces Jointes"),
                            const SizedBox(height: 15),
                            _buildDocumentsGrid(_studentData),
                          ],
                        ),
                      ),
                    ),
                    _buildModernActions(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(30, 40, 30, 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 1, 91, 237), Color(0xFF334155)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          // PHOTO STATIQUE (FORCÉE)
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border:
                  Border.all(color: Colors.white.withOpacity(0.3), width: 2),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2)
              ],
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white24,
              backgroundImage: AssetImage(
                  _staticProfileImagePath), // Utilisation de AssetImage
              // Fallback si l'image ne charge pas
              onBackgroundImageError: (_, __) =>
                  const Icon(Icons.person, size: 50),
            ),
          ),
          const SizedBox(width: 25),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.studentName,
                  style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.alternate_email,
                          size: 14, color: Colors.blueAccent),
                      const SizedBox(width: 8),
                      Text(
                        _studentData?['email'] ?? "Email non renseigné",
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(12),
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  // --- LES AUTRES WIDGETS RESTENT INCHANGÉS ---

  Widget _buildStatusBanner(String date) {
    String statusStr =
        _applicationData?['status']?.toString().toUpperCase() ?? "EN ATTENTE";
    Color color = statusStr == "ACCEPTED"
        ? Colors.teal
        : (statusStr == "REJECTED" ? Colors.redAccent : Colors.orange);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.event_note, color: Colors.blueGrey.shade600, size: 20),
              const SizedBox(width: 10),
              Text("Postulé le $date",
                  style: TextStyle(
                      color: Colors.blueGrey.shade700,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          Chip(
            label: Text(statusStr,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold)),
            backgroundColor: color,
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoGrid() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          _infoRow(Icons.account_balance_rounded, "Établissement",
              _studentData?['universite']),
          const Divider(height: 30, color: Color(0xFFF1F5F9)),
          _infoRow(
              Icons.school_outlined, "Niveau d'études", _studentData?['annee']),
          const Divider(height: 30, color: Color(0xFFF1F5F9)),
          _infoRow(
              Icons.phone_android_rounded, "Téléphone", _studentData?['phone']),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String? value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, size: 22, color: const Color(0xFF2563EB)),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    color: Colors.blueGrey.shade400,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
            Text(value ?? "Non spécifié",
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B))),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF64748B)),
        const SizedBox(width: 10),
        Text(title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF334155))),
      ],
    );
  }

  Widget _buildDocumentsGrid(Map<String, dynamic>? data) {
    final List<dynamic> docs = data?['documents'] ?? [];
    if (docs.isEmpty) return _buildEmptyDocs();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        mainAxisExtent: 80,
      ),
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final doc = docs[index];
        final String name = doc['fileName'] ?? "Document";
        bool isPdf = name.toLowerCase().endsWith('.pdf');
        return InkWell(
          onTap: () => _downloadFileWeb(
              base64String: doc['fileData'], fileName: name, context: context),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Icon(isPdf ? Icons.picture_as_pdf_rounded : Icons.image_rounded,
                    color: isPdf ? Colors.redAccent : Colors.indigoAccent,
                    size: 30),
                const SizedBox(width: 12),
                Expanded(
                    child: Text(name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600))),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyDocs() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20)),
      child: const Center(child: Text("Aucun document joint")),
    );
  }

  Widget _buildModernActions() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFF1F5F9)))),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => _updateStatus(InternshipStatus.rejected),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.redAccent),
                foregroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 22),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text("REFUSER",
                  style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _updateStatus(InternshipStatus.accepted),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 22),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: const Text("ACCEPTER LE CANDIDAT",
                  style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
    );
  }

  void _downloadFileWeb(
      {required String base64String,
      required String fileName,
      required BuildContext context}) {
    try {
      String cleanBase64 = base64String.contains(',')
          ? base64String.split(',').last
          : base64String;
      final bytes = base64Decode(cleanBase64);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute("download", fileName)
        ..click();
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur de téléchargement")));
    }
  }
}
