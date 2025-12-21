import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:med/core/Theme/Textstyle.dart';
import 'package:med/core/Theme/backgroundTheme.dart';
import 'package:med/features/widgets/appbar.dart';

class AccueilScreen extends StatelessWidget {
  const AccueilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Style pour le bouton Elevated
    final elevatedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      minimumSize: const Size(160, 45),
      textStyle: const TextStyle(
        fontFamily: 'SF Pro',
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );

    // Style pour le bouton Outlined
    final outlinedButtonStyle = OutlinedButton.styleFrom(
      foregroundColor: Colors.blue,
      backgroundColor: Colors.white,
      side: const BorderSide(color: Colors.white),
      minimumSize: const Size(160, 45),
      textStyle: const TextStyle(
        fontFamily: 'SF Pro',
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Scaffold(
      appBar: const CustomAppbar(),
      body: Container(
        decoration: Backgroundtheme.getGradientBackground(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  'Trouvez votre stage hospitalier et gérez votre \n progression en toute simplicité',
                  style: AppTextStyle.title1,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Trouvez, suivez et validez vos stages médicaux facilement',
                style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 2.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Bouton principal avec style défini localement
                  ElevatedButton.icon(
                    onPressed: () {
                      print("🔵 LOGIN BUTTON PRESSED");
                      print("Trying: context.go('/login')");
                      context.go('/login');
                    },
                    style: elevatedButtonStyle,
                    icon: const Icon(Icons.arrow_circle_right_outlined),
                    label: const Text('Se connecter'),
                  ),
                  const SizedBox(width: 40),
                  // Bouton secondaire avec style défini localement
                  OutlinedButton.icon(
                    onPressed: () {},
                    style: outlinedButtonStyle,
                    icon: const Icon(Icons.arrow_circle_right_outlined),
                    label: const Text('Voir la démo'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}