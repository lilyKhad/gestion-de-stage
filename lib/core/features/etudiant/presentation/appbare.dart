import 'package:flutter/material.dart';



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
          // Appimages.logo,
          const SizedBox(width: 10),
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
          // Navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                 
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
              TextButton(
                onPressed: () {
                  // context.push('/compteEtudiant');
                },
                child: const Text(
                  'Mon Compte',
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
          // This Spacer pushes the icons to the right edge
          const Spacer(),
          // Icons row - now with proper spacing
          Row(
            mainAxisSize: MainAxisSize.min, // Important: prevents extra spacing
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none, color: Colors.black),
              ),// Control spacing between icons
              
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

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}