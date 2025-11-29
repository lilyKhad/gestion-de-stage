import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/cloudcommerceprocurement/v1.dart';
import 'package:med/core/features/Internship/presentation/internship_list_screen.dart';
import 'package:med/core/features/auth/presentation/login.dart';
import 'package:med/core/features/etudiant/presentation/student_profile_screen.dart';
import 'package:med/core/features/etudiant/providers/student_providers.dart';

class AppbarEtudiant extends StatelessWidget implements PreferredSizeWidget {
  const AppbarEtudiant({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'MedStage',
            style: TextStyle(
              color: Colors.blue,
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
              // Simple profile menu without student data
              PopupMenuButton<String>(
                icon: const CircleAvatar(
                  radius: 16,
                  backgroundColor: Color.fromARGB(255, 174, 199, 220),
                  child: Icon(Icons.person, size: 16, color: Colors.blue),
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
                        Text('Déconnecter', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
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
                Navigator.pushAndRemoveUntil(
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