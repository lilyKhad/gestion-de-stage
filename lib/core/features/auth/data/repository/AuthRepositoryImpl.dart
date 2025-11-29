import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med/core/errors/failures.dart';
import 'package:med/core/features/auth/domain/entities/user.dart'; // Import UserEntity
import 'package:med/core/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final fb.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRepositoryImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      // 1. Sign in with Firebase Auth
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final fb.User? fbUser = credential.user;
      if (fbUser == null) {
        return const Left(AuthenticationFailure('No user found after sign-in.'));
      }

      final usersCollection = firestore.collection('users');
      final uid = fbUser.uid;
      final userEmail = fbUser.email!;

      // 2. Migration/Cleanup Logic
      final query = await usersCollection.where('email', isEqualTo: userEmail).limit(1).get();

      if (query.docs.isNotEmpty && query.docs.first.id != uid) {
        final oldDoc = query.docs.first;
        await usersCollection.doc(uid).set(oldDoc.data());
        await oldDoc.reference.delete();
      }

      // 3. FETCH OR CREATE USER DOCUMENT
      final userDoc = await usersCollection.doc(uid).get();
      String role;
      
      if (!userDoc.exists) {
        role = 'etudiant';
        await _createUserDocument(uid, userEmail, role);
      } else {
        final userData = userDoc.data();
        role = userData?['role'] as String? ?? 'etudiant'; 
      }

      // 4. Create and return the Domain UserEntity
      final user = UserEntity(
        id: uid,
        email: userEmail,
        role: role,
      );

      return Right(user);
    } catch (e) {
      final errorMessage = _getErrorMessage(e);
      return Left(AuthenticationFailure(errorMessage));
    }
  }

  // ----------------------------------------------------
  // Helper Methods
  // ----------------------------------------------------

  Future<void> _createUserDocument(String uid, String email, String role) async {
    await firestore.collection('users').doc(uid).set({
      'email': email,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  String _getErrorMessage(dynamic e) {
    if (e is fb.FirebaseAuthException) {
      return switch (e.code) {
        'user-not-found' => 'No user found with this email.',
        'wrong-password' => 'Wrong password provided.',
        'invalid-email' => 'Email address is invalid.',
        'user-disabled' => 'This user has been disabled.',
        'too-many-requests' => 'Too many requests. Try again later.',
        _ => 'Authentication failed: ${e.message}',
      };
    }
    final errorString = e.toString().toLowerCase();
    if (errorString.contains('network-request-failed')) return 'Network error. Please check your connection.';
    return 'Authentication failed: ${e.toString()}';
  }

  // ----------------------------------------------------
  // Overridden Methods
  // ----------------------------------------------------

  @override
  Future<UserEntity?> currentUser() async {
    final fbUser = firebaseAuth.currentUser;
    if (fbUser != null) {
      final usersCollection = firestore.collection('users');
      final userDoc = await usersCollection.doc(fbUser.uid).get();
      final userEmail = fbUser.email ?? '';

      if (userDoc.exists) {
        final userData = userDoc.data();
        final role = userData?['role'] as String? ?? 'etudiant'; 
        return UserEntity(id: fbUser.uid, email: userEmail, role: role);
      } else {
        const role = 'etudiant';
        await _createUserDocument(fbUser.uid, userEmail, role);
        return UserEntity(id: fbUser.uid, email: userEmail, role: role);
      }
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }
}