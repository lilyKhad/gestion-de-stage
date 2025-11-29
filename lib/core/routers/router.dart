import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med/core/features/Internship/presentation/internship_list_screen.dart';
import 'package:med/core/features/auth/presentation/login.dart';
import 'package:med/core/features/auth/provider/loginProviders.dart';
import 'package:med/core/features/etudiant/presentation/student_profile_screen.dart';


final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final authState = ref.watch(authStateProvider);
      final isAuthenticated = authState.value != null;
      final isLoggingIn = state.uri.toString() == '/login';
      final user = authState.value;

      // If user is not authenticated and trying to access protected route
      if (!isAuthenticated && !isLoggingIn) {
        return '/login';
      }

      // If user is authenticated and trying to access login
      if (isAuthenticated && isLoggingIn) {
         return _getRouteForRole(user!.role);
      }

      // No redirect needed
      return null;
    },
    routes: [
      // Login route
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) =>  LoginScreen(),
      ),

      // Protected routes
      GoRoute(
        path: '/student',
        name: 'student',
        builder: (context, state) => const StudentProfileScreen(),
      ),
       GoRoute(
         path: '/stage',
         name: 'stage',
         builder: (context, state) => const InternshipListScreen(),
       ),
      // GoRoute(
      //   path: '/admin',
      //   name: 'admin',
      //   builder: (context, state) => const AdminDashboardScreen(),
      // ),
      // GoRoute(
      //   path: '/home',
      //   name: 'home',
      //   builder: (context, state) => const HomeScreen(),
      // ),

      // // Redirect root to login
      // GoRoute(
      //   path: '/',
      //   redirect: (state) => '/login',
      // ),
    ],
    // errorBuilder: (context, state) => Scaffold(
    //   body: Center(
    //     child: Text('Page not found: ${state.location}'),
    //   ),
    // ),
  );
});

String _getRouteForRole(String role) {
  switch (role.toLowerCase()) {
    case 'etudiant':
      return '/student';
    case 'professeur':
      return '/teacher';
    case 'admin':
      return '/admin';
    default:
      return '/home';
  }
}