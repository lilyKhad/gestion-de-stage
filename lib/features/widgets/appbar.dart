import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:med/core/Theme/appColors.dart';
import 'package:med/core/images/images.dart';
class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center, //  vertical centering
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
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                 onPressed: () {context.push('/');},
                 child: const Text(
                  'Accueil',
                  style: TextStyle(
                     color: AppColors.black,
                     fontFamily: 'SF Pro',
                     fontSize: 16,
                     fontWeight: FontWeight.w500,
                   ),)),
                 
                   TextButton(
                 onPressed: () {context.push('/apropos');},
                 child: const Text(
                  'A propos',
                  style: TextStyle(
                     color: AppColors.black,
                     fontFamily: 'SF Pro',
                     fontSize: 16,
                     fontWeight: FontWeight.w500,
                   ),)),
                     TextButton(
                 onPressed: () {context.push('/contact');},
                 child: const Text(
                  'Contact',
                  style: TextStyle(
                     color: AppColors.black,
                     fontFamily: 'SF Pro',
                     fontSize: 16,
                     fontWeight: FontWeight.w500,
                   ),)),

            ],
          ),
          const Spacer(),

          ElevatedButton(
            onPressed: () {
              context.push('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Se connecter'),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}