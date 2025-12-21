import 'package:flutter/material.dart';
import 'package:med/core/Theme/backgroundTheme.dart';
import 'package:med/core/constants/Strings.dart';
import 'package:med/features/widgets/appbar.dart';

class AproposScreen extends StatelessWidget {
  const AproposScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(),
      body: Container(
        decoration: Backgroundtheme.getGradientBackground(),
        child: Padding(
          padding: const EdgeInsetsGeometry.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(90, 0, 90, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppStrings.aproposTitre1,
                      SizedBox(height: 10),
                      AppStrings.aproposSub1,
                      SizedBox(height: 30),
                      AppStrings.aproposTitre2,
                      SizedBox(height: 10),
                      AppStrings.aproposSub2,
                      SizedBox(height: 30),
                      AppStrings.aproposTitre3,
                      SizedBox(height: 10),
                      AppStrings.aproposSub3,
                      SizedBox(height: 30),
                      AppStrings.aproposTitre4,
                      SizedBox(height: 10),
                      AppStrings.aproposSub4,
                      SizedBox(height: 30),
                      AppStrings.aproposTitre5,
                      SizedBox(height: 10),
                      AppStrings.aproposSub5,
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Image.asset('assets/Apropos/femme.png')
                
                  
                // Utilisation de la constante depuis images.dart
              ),
            ],
          ),
        ),
      ),
    );
  }
}
