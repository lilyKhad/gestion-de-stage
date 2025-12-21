import 'package:flutter/material.dart';

class Backgroundtheme {
  Backgroundtheme._();
  // Method to get gradient background
  static BoxDecoration getGradientBackground() {
    return BoxDecoration(
      gradient: LinearGradient(
        // ignore: deprecated_member_use
        colors: [Colors.white, Colors.blue.withOpacity(0.17) ],// bas : bleu très léger],
        stops: const [0.2, 1.0],              // début à 0%, fin à 100%
        begin: Alignment.topCenter,     // du haut vers le bas
        end: Alignment.bottomCenter,
      ),
    );
  }
}

