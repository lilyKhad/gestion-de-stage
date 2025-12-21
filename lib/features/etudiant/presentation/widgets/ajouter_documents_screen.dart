import 'dart:convert';
import 'dart:typed_data';
import 'dart:io' as io; // Import as 'io' to avoid conflicts on Web

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // To check if running on Web
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';

class AjouterDocumentScreen extends ConsumerStatefulWidget {
  const AjouterDocumentScreen({super.key});

  @override
  ConsumerState<AjouterDocumentScreen> createState() =>
      _AjouterDocumentScreenState();
}

class _AjouterDocumentScreenState extends ConsumerState<AjouterDocumentScreen> {
  // Use PlatformFile to handle both Web and Mobile metadata generically
  PlatformFile? selectedFile; 
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView( // Added scroll view for smaller screens
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Gestion des Documents',
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 8),
              const Text(
                'Téléchargez et gérez votre document médical (Max 700KB)',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              _buildDocumentCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentCard(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.description, color: Colors.blue, size: 24),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Document Médical',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Téléchargez votre document médical ici. Formats acceptés: PDF, DOC, JPG, PNG.\nNote: Stockage direct dans Firestore (limité aux petits fichiers).',
              style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
            ),
            const SizedBox(height: 20),
            
            // Upload button area
            Row(
              children: [
                Expanded(
                  child: Text(
                    selectedFile != null
                        ? 'Fichier: ${selectedFile!.name} \n(${_formatBytes(selectedFile!.size)})'
                        : 'Aucun fichier sélectionné',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _pickFile,
                  icon: const Icon(Icons.upload, size: 18),
                  label: const Text('Choisir'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Save button
            if (selectedFile != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _uploadToFirestore,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: _isLoading 
                    ? const SizedBox(
                        height: 20, 
                        width: 20, 
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      )
                    : const Text('Enregistrer dans Firestore'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
        // Important: withData: true ensures bytes are available on Web.
        // On Mobile, we will ignore the bytes in result and read from path to save RAM.
        withData: kIsWeb, 
      );

      if (result != null) {
        setState(() {
          selectedFile = result.files.first;
        });
      }
    } catch (e) {
      _showErrorDialog('Erreur lors de la sélection: $e');
    }
  }

  Future<void> _uploadToFirestore() async {
  if (selectedFile == null) return;

  setState(() => _isLoading = true);

  try {
    Uint8List? fileBytes;

    // 1. Get the bytes depending on the platform
    if (kIsWeb) {
      fileBytes = selectedFile!.bytes;
    } else {
      if (selectedFile!.path != null) {
        final file = io.File(selectedFile!.path!);
        fileBytes = await file.readAsBytes();
      }
    }

    if (fileBytes == null) {
      throw Exception("Impossible de lire les données du fichier.");
    }

    // 2. Convert to Base64
    final base64Data = base64Encode(fileBytes);

    // 3. Check Firestore Limit (1 MiB = 1,048,576 bytes)
    // We set a safe limit of ~750KB because Base64 increases size by ~33%
    if (base64Data.length > 1048000) {
      throw Exception('Fichier trop volumineux. La limite Firestore est de 1MB.');
    }

    // 4. Check Auth
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Vous devez être connecté.');
    }

    // 5. Create the Document Object (Matches StudentDocument structure)
    // We use DateTime.now().millisecondsSinceEpoch for easier serialization
    final Map<String, dynamic> newDocument = {
      'fileName': selectedFile!.name,
      'fileData': base64Data, 
      'fileType': _getFileType(selectedFile!.extension ?? ''),
      'uploadedAt': DateTime.now().millisecondsSinceEpoch, 
    };

    // 6. Update the User in Firestore
    // We use arrayUnion to append to the list without overwriting existing docs
    await FirebaseFirestore.instance
        .collection('users') // Assuming your collection is named 'users'
        .doc(user.uid)
        .update({
          'documents': FieldValue.arrayUnion([newDocument]),
        });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Document ajouté à votre profil avec succès!')),
      );
      setState(() {
        selectedFile = null;
      });
    }
    
  } catch (e) {
    if (mounted) _showErrorDialog(e.toString());
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}

  String _getFileType(String extension) {
    final ext = extension.toLowerCase().replaceAll('.', '');
    if (ext == 'pdf') return 'pdf';
    if (['jpg', 'jpeg', 'png'].contains(ext)) return 'image';
    if (['doc', 'docx'].contains(ext)) return 'document';
    return 'other';
  }
  
  // Helper to display size
  String _formatBytes(int bytes, {int decimals = 2}) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (bytes.bitLength - 1) ~/ 10; // Simple log calculation
    if (i >= suffixes.length) i = suffixes.length - 1; // prevent index out of range
    // Adjust logic for simple display
    if (bytes < 1024) return "$bytes B";
    double size = bytes / (1 << (i * 10)); // bit shift for powers of 1024
    // Recalculate index for correct suffix
    int suffixIndex = 0;
    double v = bytes.toDouble();
    while (v >= 1024 && suffixIndex < suffixes.length - 1) {
      v /= 1024;
      suffixIndex++;
    }
    return '${v.toStringAsFixed(decimals)} ${suffixes[suffixIndex]}';
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Erreur'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))
        ],
      ),
    );
  }
}