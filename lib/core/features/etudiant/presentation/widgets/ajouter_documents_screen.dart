import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

class AjouterDocumentScreen extends ConsumerStatefulWidget {
  const AjouterDocumentScreen({super.key});

  @override
  ConsumerState<AjouterDocumentScreen> createState() =>
      _AjouterDocumentScreenState();
}

class _AjouterDocumentScreenState
    extends ConsumerState<AjouterDocumentScreen> {
  File? selectedFile;
  Uint8List? fileBytes; // for web compatibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Ajouter Document')),
      body: Padding(
        padding: const EdgeInsets.all(24),
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
              'Téléchargez et gérez votre document médical',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            _buildDocumentCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentCard(BuildContext context) {
    return Card(
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
              'Téléchargez votre document médical ici. Formats acceptés: PDF, DOC, JPG, PNG.',
              style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
            ),
            const SizedBox(height: 20),
            // Upload button
            Row(
              children: [
                Expanded(
                  child: Text(
                    selectedFile != null
                        ? 'Fichier sélectionné: ${p.basename(selectedFile!.path)}'
                        : 'Aucun fichier sélectionné',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.upload, size: 18),
                  label: const Text('Télécharger'),
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
            if (selectedFile != null || fileBytes != null)
              ElevatedButton(
                onPressed: _uploadToFirestore,
                child: const Text('Enregistrer'),
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
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
        withData: true, // <-- Important for web
      );

      if (result != null) {
        // Mobile: store as File
        if (result.files.single.path != null) {
          setState(() {
            selectedFile = File(result.files.single.path!);
            fileBytes = null; // reset
          });
        } else if (result.files.single.bytes != null) {
          // Web: store bytes
          setState(() {
            fileBytes = result.files.single.bytes;
            selectedFile = null;
          });
        }
      }
    } catch (e) {
      _showErrorDialog('Erreur: $e');
    }
  }
Future<void> _uploadToFirestore() async {
  try {
    Uint8List? bytes;
    String fileName;

    if (selectedFile != null) {
      bytes = await selectedFile!.readAsBytes();
      fileName = p.basename(selectedFile!.path); // assigned here
    } else if (fileBytes != null) {
      bytes = fileBytes;
      fileName = "document_${DateTime.now().millisecondsSinceEpoch}"; // assigned here
    } else {
      _showErrorDialog('Aucun fichier sélectionné.');
      return; // early exit ensures fileName is never used uninitialized
    }

    // Safety check for size
    if (bytes!.length > 1000000) {
      _showErrorDialog('Le fichier est trop gros pour Firestore (max 1MB).');
      return;
    }

    final base64Data = base64Encode(bytes as List<int>);

    await FirebaseFirestore.instance.collection('documents').add({
      'fileName': fileName,
      'fileData': base64Data,
      'uploadedAt': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Document enregistré avec succès!')),
    );

    setState(() {
      selectedFile = null;
      fileBytes = null;
    });
  } catch (e) {
    _showErrorDialog('Erreur: $e');
  }
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
