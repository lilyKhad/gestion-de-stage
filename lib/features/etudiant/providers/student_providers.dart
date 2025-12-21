import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:med/core/errors/failures.dart';
import 'package:med/features/etudiant/data/data_source/student_firebase_datasource.dart';
import 'package:med/features/etudiant/data/repository/student_repository_impl.dart';
import 'package:med/features/etudiant/domain/repositories/etudiant_repository.dart';
import 'package:med/features/etudiant/domain/usecases/getetudiant_usecase.dart';
import 'package:med/features/etudiant/domain/usecases/update_phot.dart';
import 'package:med/features/etudiant/domain/usecases/upload_document_usecase.dart';

// ============================
// Firebase instance provider
// ============================
final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// ============================
// Remote data source provider
// ============================
final studentRemoteDataSourceProvider = Provider<StudentRemoteDataSource>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return StudentRemoteDataSource(firestore);
});

// ============================
// Repository provider
// ============================
final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  final remoteDataSource = ref.watch(studentRemoteDataSourceProvider);
  return StudentRepositoryImpl(remoteDataSource);
});

// ============================
// Use case providers
// ============================
final getStudentUseCaseProvider = Provider<GetStudentUseCase>((ref) {
  final repository = ref.watch(studentRepositoryProvider);
  return GetStudentUseCase(repository);
});

final updateProfilePictureUseCaseProvider = Provider<UpdateProfilePicture>((ref) {
  final repository = ref.watch(studentRepositoryProvider);
  return UpdateProfilePicture(repository);
});



final uploadDocumentUseCaseProvider = Provider<UploadDocument>((ref) {
  final repository = ref.watch(studentRepositoryProvider);
  return UploadDocument(repository);
});

// ============================
// FutureProviders for UI
// ============================

// Get Student by ID
final studentProvider = FutureProvider.family((ref, String studentId) async {
  final useCase = ref.read(getStudentUseCaseProvider);
  return await useCase(studentId);
});


// Upload document
final uploadDocumentProvider =
    FutureProvider.family<Either<Failure, String>, Map<String, String>>(
  (ref, data) async {
    final useCase = ref.read(uploadDocumentUseCaseProvider);
    return await useCase(
      data['studentId']!,
      data['filePath']!,
      data['documentType']!,
    );
  },
);

// ============================
// Sidebar State Providers
// ============================

// Current selected index of sidebar
final sidebarSelectedIndexProvider = StateProvider<int>((ref) => 3);

// Sidebar expanded/collapsed
final sidebarExpandedProvider = StateProvider<bool>((ref) => true);
