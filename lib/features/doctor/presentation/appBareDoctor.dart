import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med/core/Theme/appColors.dart';
import 'package:med/core/images/images.dart';
import 'package:med/features/auth/presentation/login.dart';
import 'package:med/features/etudiant/presentation/student_profile_screen.dart';

class AppbarDoctor extends StatelessWidget implements PreferredSizeWidget {
  const AppbarDoctor({super.key});

  // Fonction pour transformer le lien Google Drive en lien d'image direct
  String? _convertDriveUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    if (url.contains("drive.google.com")) {
      final uri = Uri.parse(url);
      final fileId = uri.queryParameters['id'];
      if (fileId != null) {
        // Nouveau format stable pour afficher les images Drive en 2025
        return "https://lh3.googleusercontent.com/d/$fileId";
      }
    }
    return url; // Retourne l'url d'origine si ce n'est pas du Google Drive
  }

  @override
  Widget build(BuildContext context) {
    // Récupération de l'UID de l'utilisateur connecté
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
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
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none, color: Colors.black),
              ),
              const SizedBox(width: 8),

              // --- FUTURE BUILDER POUR LA PHOTO ---
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .get(),
                builder: (context, snapshot) {
                  String? finalImageUrl;

                  if (snapshot.hasData && snapshot.data!.exists) {
                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    // Conversion du lien ici
                    finalImageUrl = _convertDriveUrl(data['pictureUrl']);
                  }

                  return PopupMenuButton<String>(
                    tooltip: "Menu profil",
                    icon: CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color.fromARGB(255, 174, 199, 220),
                      // Affichage de l'image si elle existe, sinon icône
                      backgroundImage: (finalImageUrl != null)
                          ? NetworkImage(finalImageUrl)
                          : null,
                      child: (finalImageUrl == null)
                          ? const Icon(Icons.person,
                              size: 18, color: Colors.blue)
                          : null,
                    ),
                    onSelected: (value) {
                      if (value == 'logout') {
                        _showLogoutDialog(context);
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(Icons.logout, color: Colors.red, size: 20),
                            SizedBox(width: 8),
                            Text('Déconnecter',
                                style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              // ------------------------------------
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
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                }
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
