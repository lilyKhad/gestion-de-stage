import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med/features/%C3%89tablissements/presentation/HospitalDashboard.dart';
import 'package:med/features/%C3%89tablissements/presentation/create_internship.dart';
import 'package:med/features/Internship/presentation/list_cards.dart';
import 'package:med/features/acceuilFeature/presenation/acceuil.dart';
import 'package:med/features/acceuilFeature/presenation/apropos.dart';
import 'package:med/features/acceuilFeature/presenation/contact.dart';
import 'package:med/features/auth/presentation/login.dart';
import 'package:med/features/auth/provider/loginProviders.dart';
import 'package:med/features/doctor/presentation/doctormain.dart';
import 'package:med/features/doyen/presentation/admin.dart';
import 'package:med/features/etudiant/presentation/student_profile_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final authState = ref.watch(authStateProvider);
      final user = authState.value;
      final isAuthenticated = user != null;

      final path = state.uri.toString();

      print('--- REDIRECT DEBUG ---');
      print('Requested path: $path');
      print('Authenticated: $isAuthenticated');
      print('User role: ${user?.role}');
      print('Is public route: ${_isPublicRoute(path)}');

      // 🔒 NOT AUTHENTICATED
      if (!isAuthenticated && !_isPublicRoute(path)) {
        print('🔒 NOT AUTHENTICATED → /login');
        return '/login';
      }

      // ✅ AUTHENTICATED → redirect root only
      if (isAuthenticated && path == '/') {
        final roleRoute = _getRouteForRole(user.role);
        print('🔁 AUTH → $roleRoute');
        return roleRoute;
      }

      print('✔️ NO REDIRECT');
      return null;
    },
    routes: [
      // ---------------- PUBLIC ----------------
      GoRoute(
        path: '/',
        name: 'accueil',
        builder: (context, state) => const AccueilScreen(),
        routes: [
          GoRoute(
            path: 'apropos',
            name: 'apropos',
            builder: (context, state) => const AproposScreen(),
          ),
          GoRoute(
            path: 'contact',
            name: 'contact',
            builder: (context, state) => const ContactScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // ---------------- MEDCIN ----------------
      GoRoute(
        path: '/medecin',
        name: 'medecin',
        builder: (context, state) => const DashboardBody(),
      ),
      ///-----------Admin--------------
       GoRoute(
        path: '/admin',
        name: 'admin',
        builder: (context, state) => const DeanDashboardScreen(),
      ),

      // ---------------- ETUDIANT ----------------
      GoRoute(
        path: '/etudiant',
        name: 'etudiant',
        builder: (context, state) => const StudentProfileScreen(),
      ),

      // ---------------- STAGE ----------------
      GoRoute(
        path: '/stage',
        name: 'stage',
        builder: (context, state) => const InternshipListScreen(),
      ),

      // ---------------- HÔPITAL ----------------
      GoRoute(
        path: '/hopital',
        name: 'hopital',
        builder: (context, state) => const HospitalDashboard(),
        routes: [
          GoRoute(
            path: 'create',
            name: 'create_internship',
            builder: (context, state) =>
                const CreateInternshipScreen(hospitalName: "Chargement..."),
          ),
        ],
      ),
    ],
  );
});
bool _isPublicRoute(String path) {
  return path == '/' ||
      path.startsWith('/login') ||
      path.startsWith('/apropos') ||
      path.startsWith('/contact');
}

String _getRouteForRole(String role) {
  switch (role.toLowerCase()) {
    case 'etudiant':
      return '/etudiant';
    case 'medecin':
      return '/medecin';
    case 'admin':
    case 'doyen':  // <--- Pour correspondre à votre base de données
      return '/admin';
    case 'hopital':
    case 'epsp':
      return '/hopital';
    default:
      return '/';
  }
}
