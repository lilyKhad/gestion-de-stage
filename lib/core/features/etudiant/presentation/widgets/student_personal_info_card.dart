import 'package:flutter/material.dart';
import 'package:med/core/features/etudiant/domain/entities/etudiant.dart';
import 'student_info_row.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StudentPersonalInfoCard extends StatelessWidget {
  final Student student;

  const StudentPersonalInfoCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),

              const Text('Informations Personnelles',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              StudentInfoRow(label: 'Email', value: student.email),
              StudentInfoRow(label: 'Téléphone', value: student.phone),
              StudentInfoRow(label: 'Adresse', value: student.adresse),

              const SizedBox(height: 20),
              const Text('Informations Académiques',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              StudentInfoRow(label: 'Université', value: student.universite),
              StudentInfoRow(label: 'Année', value: student.annee),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        _buildProfileImage(),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${student.prenom} ${student.nom}',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                student.birthday,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
        )
      ],
    );
  }

  String _getOptimizedPhotoUrl(String originalUrl) {
    // If URL is empty or invalid, return empty string
    if (originalUrl.isEmpty || originalUrl.contains('MyfileId')) {
      return '';
    }

    // Try to extract file ID from various Google Drive URL formats
    String? fileId;
    
    // Pattern 1: googleusercontent.com/d/{fileId}
    final pattern1 = RegExp(r'googleusercontent\.com/d/([a-zA-Z0-9_-]+)');
    final match1 = pattern1.firstMatch(originalUrl);
    if (match1 != null) {
      fileId = match1.group(1);
    }
    
    // Pattern 2: drive.google.com/uc?export=view&id={fileId}
    final pattern2 = RegExp(r'[?&]id=([a-zA-Z0-9_-]+)');
    final match2 = pattern2.firstMatch(originalUrl);
    if (match2 != null) {
      fileId = match2.group(1);
    }
    
    // Pattern 3: drive.google.com/file/d/{fileId}
    final pattern3 = RegExp(r'/file/d/([a-zA-Z0-9_-]+)');
    final match3 = pattern3.firstMatch(originalUrl);
    if (match3 != null) {
      fileId = match3.group(1);
    }

    if (fileId != null) {
      // Use Google's thumbnail service with different sizes
      // s400 = 400px size, c = crop
      return 'https://lh3.googleusercontent.com/d/$fileId=s400-c';
    }
    
    // If we can't extract a file ID but it's a valid URL, use the original
    if (originalUrl.startsWith('http')) {
      return originalUrl;
    }
    
    return '';
  }

  Widget _buildProfileImage() {
    final photoUrl = _getOptimizedPhotoUrl(student.photoUrl);
    
    final hasValidPhoto = photoUrl.isNotEmpty && photoUrl.startsWith('http');

    if (!hasValidPhoto) {
      return _buildInitialsAvatar();
    }

    // Test the URL first with a regular Image.network to see if it works
    return _buildImageWithFallback(photoUrl);
  }

  Widget _buildImageWithFallback(String photoUrl) {
    return Stack(
      children: [
        // Try CachedNetworkImage first
        CachedNetworkImage(
          imageUrl: photoUrl,
          imageBuilder: (context, imageProvider) => CircleAvatar(
            radius: 40,
            backgroundImage: imageProvider,
          ),
          placeholder: (context, url) => _buildInitialsAvatar(),
          errorWidget: (context, url, error) {
            print('❌ CachedNetworkImage failed, trying Image.network...');
            // If CachedNetworkImage fails, try regular Image.network
            return _buildNetworkImageWithRetry(photoUrl);
          },
        ),
      ],
    );
  }

  Widget _buildNetworkImageWithRetry(String photoUrl) {
    return ClipOval(
      child: Image.network(
        photoUrl,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildInitialsAvatar();
        },
        errorBuilder: (context, error, stackTrace) {
          print('❌ Both image loaders failed for URL: $photoUrl');
          print('📌 Original student URL: ${student.photoUrl}');
          return _buildInitialsAvatar();
        },
      ),
    );
  }

  Widget _buildInitialsAvatar() {
    final initials = '${student.prenom.isNotEmpty ? student.prenom[0] : ''}'
                     '${student.nom.isNotEmpty ? student.nom[0] : ''}'
                     .toUpperCase();
    
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials.isEmpty ? '?' : initials,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}