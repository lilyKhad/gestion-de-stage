// Application Remote Data Source
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med/core/features/Condidature/domain/entity/condidature.dart';
import 'package:med/core/features/Condidature/providers/condidature_providers.dart';
import 'package:med/core/features/application/data/remotedata.dart';
import 'package:med/core/features/application/data/repository/app_repoImpl.dart';
import 'package:med/core/features/application/domain/entity/application.dart';
import 'package:med/core/features/application/domain/repository/application_repository.dart';
import 'package:med/core/features/application/domain/usecases/applicatio_usescases.dart';
final applicationRemoteDataSourceProvider = Provider<ApplicationRemoteDataSource>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return ApplicationRemoteDataSource(firestore);
});

// Application Repository
final applicationRepositoryProvider = Provider<ApplicationRepository>((ref) {
  final remoteDataSource = ref.watch(applicationRemoteDataSourceProvider);
  return ApplicationRepositoryImpl(remoteDataSource);
});

// Application Use Cases
final addApplicationUseCaseProvider = Provider<AddApplicationUseCase>((ref) {
  final repository = ref.watch(applicationRepositoryProvider);
  return AddApplicationUseCase(repository);
});

final getApplicationsByStudentUseCaseProvider = Provider<GetApplicationsByStudentUseCase>((ref) {
  final repository = ref.watch(applicationRepositoryProvider);
  return GetApplicationsByStudentUseCase(repository);
});

final getApplicationsByInternshipUseCaseProvider = Provider<GetApplicationsByInternshipUseCase>((ref) {
  final repository = ref.watch(applicationRepositoryProvider);
  return GetApplicationsByInternshipUseCase(repository);
});

final updateApplicationStatusUseCaseProvider = Provider<UpdateApplicationStatusUseCase>((ref) {
  final repository = ref.watch(applicationRepositoryProvider);
  return UpdateApplicationStatusUseCase(repository);
});

// Application Future/Stream Providers - USE ONLY ONE OF THESE APPROACHES:

// OPTION 1: Using Clean Architecture (Recommended)
final applicationsByStudentProvider = StreamProvider.autoDispose
    .family<List<ApplicationEntity>, String>((ref, studentId) {
  final useCase = ref.read(getApplicationsByStudentUseCaseProvider);
  return useCase(studentId);
});

final applicationsByInternshipProvider = StreamProvider.autoDispose
    .family<List<ApplicationEntity>, String>((ref, internshipId) {
  final useCase = ref.read(getApplicationsByInternshipUseCaseProvider);
  return useCase(internshipId);
});

final addApplicationProvider = FutureProvider.family<void, ApplicationEntity>((ref, application) async {
  final useCase = ref.read(addApplicationUseCaseProvider);
  await useCase(application);
});

final updateApplicationStatusProvider = FutureProvider.family<void, ({String applicationId, CondidatureStatus status})>((ref, params) async {
  final useCase = ref.read(updateApplicationStatusUseCaseProvider);
  await useCase(params.applicationId, params.status);
});

// REMOVE THIS DUPLICATE DEFINITION:
// final applicationsByStudentProvider = StreamProvider.autoDispose
//     .family<List<ApplicationEntity>, String>((ref, studentId) {
//   return FirebaseFirestore.instance
//       .collection('applications')
//       .where('studentId', isEqualTo: studentId)
//       .orderBy('appliedAt', descending: true)
//       .snapshots()
//       .map((snapshot) => snapshot.docs
//           .map((doc) => ApplicationEntity.fromMap(doc.id, doc.data()))
//           .toList());
// });