import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:med/core/features/auth/data/repository/AuthRepositoryImpl.dart';
import 'package:med/core/features/auth/domain/repositories/auth_repository.dart';
import 'package:med/core/features/auth/domain/entities/user.dart'; // Import your UserEntity
// Repository providers
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final firebaseAuthProvider = Provider<fb.FirebaseAuth>((ref) {
  return fb.FirebaseAuth.instance;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firestoreProvider),
  );
});

// Global auth state provider - returns your UserEntity
final authStateProvider = StreamProvider<UserEntity?>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final firestore = ref.watch(firestoreProvider);
  
  return firebaseAuth.authStateChanges().asyncMap((fbUser) async {
    if (fbUser == null) return null;
    
    try {
      final userDoc = await firestore.collection('users').doc(fbUser.uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        final role = userData?['role'] as String? ?? 'etudiant';
        
        return UserEntity(
          id: fbUser.uid, 
          email: fbUser.email ?? '', 
          role: role
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  });
});

// Login controller provider
final loginControllerProvider = StateNotifierProvider<LoginController, AsyncValue<UserEntity?>>((ref) {
  return LoginController(ref.read(authRepositoryProvider));
});

// Provider to check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(authStateProvider).value;
  return user != null;
});

class LoginController extends StateNotifier<AsyncValue<UserEntity?>> {
  final AuthRepository repository;

  LoginController(this.repository) : super(const AsyncValue.data(null));

  Future<void> login({required String email, required String password}) async {
    state = const AsyncValue.loading();

    final result = await repository.login(
      email: email,
      password: password,
    );

    result.fold(
      (failure) {
        state = AsyncValue.error('Login failed: $failure', StackTrace.current);
      },
      (user) {
        state = AsyncValue.data(user);
      },
    );
  }

  Future<void> logout() async {
    try {
      await repository.logout();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error('Logout failed: $e', st);
      Future.delayed(const Duration(seconds: 2), () {
        state = const AsyncValue.data(null);
      });
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}