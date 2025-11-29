// role_navigator.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoleNavigator {
  static void navigateBasedOnRole(BuildContext context, String role) {
    switch (role.toLowerCase()) {
      case 'etudiant':
        context.go('/student');
        break;
      case 'professeur':
        context.go('/teacher');
        break;
      case 'admin':
        context.go('/admin');
        break;
      default:
        context.go('/home');
        break;
    }
  }
}