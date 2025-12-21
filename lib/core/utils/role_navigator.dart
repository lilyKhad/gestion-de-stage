// utils/role_navigator.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoleNavigator {
  static void navigateBasedOnRole(BuildContext context, String role) {
    final normalizedRole = role.toLowerCase().trim();
    
    // Handle different role naming conventions
    final roleRoutes = {
      'student': '/etudiant',
      'etudiant': '/etudiant',
      'étudiant': '/etudiant',
      'doctor': '/medecin', 
      'medecin': '/medecin',
      'médecin': '/medecin',
      'admin': '/admin',
      'administrator': '/admin',
      'hospital': '/hopital',
      'hopital': '/hopital',
      'hôpital': '/hopital',
    };

    final route = roleRoutes[normalizedRole] ?? '/etudiant';
    context.go(route);
  }
}