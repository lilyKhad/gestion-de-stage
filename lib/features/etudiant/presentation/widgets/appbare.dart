import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:med/core/Theme/appColors.dart';
import 'package:med/core/images/images.dart';
import 'package:med/features/Internship/presentation/list_cards.dart'
    show InternshipListScreen;
import 'package:med/features/auth/presentation/login.dart';
import 'package:med/features/etudiant/domain/entities/etudiant.dart';
import 'package:med/features/etudiant/presentation/student_profile_screen.dart';
import 'package:med/features/etudiant/providers/student_providers.dart';

class AppbarEtudiant extends ConsumerWidget implements PreferredSizeWidget {
  const AppbarEtudiant({super.key});

  // Chemin vers l'asset local pour la photo de profil
  final String _localProfilePhotoPath = 'assets/Apropos/etudiante.jpg';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Appimages.logo,
          const SizedBox(width: 10),
          const Text(
            'MedStage',
            style: TextStyle(
              color: AppColors.blue,
              fontFamily: 'SF Pro',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(width: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InternshipListScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Decouvrir',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'SF Pro',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StudentProfileScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Main menu',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'SF Pro',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none, color: Colors.black),
              ),
              const SizedBox(width: 8),

              // Profile avatar with student data
              if (user != null)
                _buildStudentProfileAvatar(context, ref, user.uid)
              else
                _buildDefaultAvatar(),
            ],
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: Colors.grey.shade300,
          height: 1,
        ),
      ),
    );
  }

  Widget _buildStudentProfileAvatar(
      BuildContext context, WidgetRef ref, String userId) {
    final studentAsync = ref.watch(studentProvider(userId));

    return studentAsync.when(
      data: (either) => either.fold(
        (error) => _buildLocalProfileAvatar(),
        (student) => _buildProfilePopupMenu(context, student),
      ),
      loading: () => _buildLoadingAvatar(),
      error: (error, stack) => _buildLocalProfileAvatar(),
    );
  }

  Widget _buildProfilePopupMenu(BuildContext context, Student student) {
    final photoUrl = _getOptimizedPhotoUrl(student.photoUrl);
    final hasValidPhoto = photoUrl.isNotEmpty && photoUrl.startsWith('http');
    final initials = '${student.prenom.isNotEmpty ? student.prenom[0] : ''}'
            '${student.nom.isNotEmpty ? student.nom[0] : ''}'
        .toUpperCase();

    return PopupMenuButton<String>(
      icon: _buildProfileIcon(photoUrl, hasValidPhoto, initials),
      onSelected: (value) {
        if (value == 'profile') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const StudentProfileScreen(),
            ),
          );
        } else if (value == 'logout') {
          _showLogoutDialog(context);
        }
      },
      itemBuilder: (BuildContext context) => [
        // Profile Info Section
        PopupMenuItem<String>(
          enabled: false,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildProfileImageInPopup(
                        photoUrl, hasValidPhoto, initials),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${student.prenom} ${student.nom}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            student.email,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 1,
                  color: Colors.grey.shade200,
                ),
              ],
            ),
          ),
        ),

        // Profile Action
        const PopupMenuItem<String>(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person_outline, color: Colors.blue, size: 20),
              SizedBox(width: 12),
              Text('Mon Profil', style: TextStyle(color: Colors.black87)),
            ],
          ),
        ),

        // Settings
        const PopupMenuItem<String>(
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.settings_outlined, color: Colors.grey, size: 20),
              SizedBox(width: 12),
              Text('Paramètres', style: TextStyle(color: Colors.black87)),
            ],
          ),
        ),

        // Divider
        const PopupMenuDivider(),

        // Logout
        const PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, color: Colors.red, size: 20),
              SizedBox(width: 12),
              Text('Déconnecter', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      offset: const Offset(0, 50),
    );
  }

  Widget _buildProfileIcon(
      String photoUrl, bool hasValidPhoto, String initials) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: hasValidPhoto
            ? CachedNetworkImage(
                imageUrl: photoUrl,
                imageBuilder: (context, imageProvider) => Image(
                  image: imageProvider,
                  fit: BoxFit.cover,
                  width: 30,
                  height: 30,
                ),
                placeholder: (context, url) => _buildLocalProfileImage(30),
                errorWidget: (context, url, error) =>
                    _buildLocalProfileImage(30),
              )
            : _buildLocalProfileImage(30),
      ),
    );
  }

  Widget _buildProfileImageInPopup(
      String photoUrl, bool hasValidPhoto, String initials) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: ClipOval(
        child: hasValidPhoto
            ? CachedNetworkImage(
                imageUrl: photoUrl,
                fit: BoxFit.cover,
                width: 38,
                height: 38,
                errorWidget: (context, url, error) =>
                    _buildLocalProfileImage(38),
              )
            : _buildLocalProfileImage(38),
      ),
    );
  }

  Widget _buildLocalProfileImage(double size) {
    return Image.asset(
      _localProfilePhotoPath,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // Fallback si l'asset n'existe pas
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.person,
              size: size * 0.5,
              color: Colors.blue.shade800,
            ),
          ),
        );
      },
    );
  }

  Widget _buildLocalProfileAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          _localProfilePhotoPath,
          width: 30,
          height: 30,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const CircleAvatar(
              radius: 16,
              backgroundColor: Color.fromARGB(255, 174, 199, 220),
              child: Icon(Icons.person, size: 16, color: Colors.blue),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: const CircleAvatar(
        radius: 16,
        backgroundColor: Color.fromARGB(255, 174, 199, 220),
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: const CircleAvatar(
        radius: 16,
        backgroundColor: Color.fromARGB(255, 174, 199, 220),
        child: Icon(Icons.person, size: 16, color: Colors.blue),
      ),
    );
  }

  String _getOptimizedPhotoUrl(String originalUrl) {
    // If URL is empty or invalid, return empty string to use local asset
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
      // Use Google's thumbnail service with smaller size for app bar
      return 'https://lh3.googleusercontent.com/d/$fileId=s100-c';
    }

    // If we can't extract a file ID but it's a valid URL, use the original
    if (originalUrl.startsWith('http')) {
      return originalUrl;
    }

    return '';
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 8),
              Text('Déconnexion'),
            ],
          ),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Déconnecter'),
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
