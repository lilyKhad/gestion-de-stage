import 'package:flutter/material.dart';
import 'package:med/features/etudiant/domain/entities/etudiant.dart';
import 'student_info_row.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StudentPersonalInfoCard extends StatelessWidget {
  final Student student;
  final VoidCallback? onEditImage;

  const StudentPersonalInfoCard({
    super.key, 
    required this.student,
    this.onEditImage,
  });

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProfileSection(),
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
              const SizedBox(height: 8),
              // Bouton d'édition du profil (optionnel)
              if (onEditImage != null)
                OutlinedButton.icon(
                  onPressed: onEditImage,
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Modifier la photo'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection() {
    return Stack(
      children: [
        // Photo de profil
        _buildProfileImage(),
        
        // Bouton d'édition flottant
        if (onEditImage != null)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: onEditImage,
                icon: const Icon(Icons.edit, size: 18),
                color: Colors.blue,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(6),
                  minimumSize: const Size(36, 36),
                ),
              ),
            ),
          ),
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

    return _buildImageWithFallback(photoUrl);
  }

  Widget _buildImageWithFallback(String photoUrl) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300, width: 2),
          ),
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: photoUrl,
              imageBuilder: (context, imageProvider) => Image(
                image: imageProvider,
                fit: BoxFit.cover,
                width: 96,
                height: 96,
              ),
              placeholder: (context, url) => _buildInitialsAvatar(),
              errorWidget: (context, url, error) {
                return _buildNetworkImageWithRetry(photoUrl);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNetworkImageWithRetry(String photoUrl) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      child: ClipOval(
        child: Image.network(
          photoUrl,
          width: 96,
          height: 96,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _buildInitialsAvatar();
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildInitialsAvatar();
          },
        ),
      ),
    );
  }

  Widget _buildInitialsAvatar() {
    final initials = '${student.prenom.isNotEmpty ? student.prenom[0] : ''}'
                     '${student.nom.isNotEmpty ? student.nom[0] : ''}'
                     .toUpperCase();
    
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blue.shade200, width: 2),
      ),
      child: Center(
        child: Text(
          initials.isEmpty ? '?' : initials,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade800,
          ),
        ),
      ),
    );
  }
}