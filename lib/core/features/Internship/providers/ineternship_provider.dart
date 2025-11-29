// application/providers.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med/core/features/Internship/data/datasource/remotedata/remote_data_source.dart';
import 'package:med/core/features/Internship/data/repository/internship_repositoryImpl.dart';
import 'package:med/core/features/Internship/domain/entity/internship.dart';
import 'package:med/core/features/Internship/domain/repository/internship_repo.dart';
import 'package:med/core/features/Internship/domain/usecases/getInternshi.dart';
import 'package:med/core/features/Internship/domain/usecases/searchUsecase.dart';
import 'package:riverpod/riverpod.dart';
import 'package:collection/collection.dart';


// Firebase Provider
final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// Data Source Provider
final internshipRemoteDataSourceProvider = Provider<InternshipRemoteDataSource>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return InternshipRemoteDataSource(firestore);
});

// Repository Provider
final internshipRepositoryProvider = Provider<InternshipRepository>((ref) {
  final remoteDataSource = ref.watch(internshipRemoteDataSourceProvider);
  return InternshipRepositoryImpl(remoteDataSource);
});

// Use Case Provider
final getInternshipsUseCaseProvider = Provider<GetInternshipsUseCase>((ref) {
  final repository = ref.watch(internshipRepositoryProvider);
  return GetInternshipsUseCase(repository);
});

// Main Internships Provider
final internshipsProvider = FutureProvider<List<Internship>>((ref) async {
  final getInternships = ref.watch(getInternshipsUseCaseProvider);
  return await getInternships.call();
});

// application/providers.dart
final searchInternshipsUseCaseProvider = Provider<SearchInternshipsUseCase>((ref) {
  final repository = ref.watch(internshipRepositoryProvider);
  return SearchInternshipsUseCase(repository);
});

// application/providers.dart
final searchInternshipsProvider = FutureProvider.family<List<Internship>, String>((ref, query) async {
  final searchUseCase = ref.watch(searchInternshipsUseCaseProvider);

  // Split query into department/doctor (simplest example)
  final lowerQuery = query.toLowerCase();

  // You can customize this to search department or doctor name
  return (await searchUseCase.call()).where((internship) {
    final department = internship.department.toLowerCase();
    final doctor = internship.doctorName.toLowerCase();
    return department.contains(lowerQuery) || doctor.contains(lowerQuery);
  }).toList();
});

final internshipByIdProvider = FutureProvider.family<Internship?, String>((ref, internshipId) async {
  final getInternships = ref.read(getInternshipsUseCaseProvider);
  final internships = await getInternships();
  
  print('🔍 Looking for internship with ID: $internshipId');
  print('📊 Total internships available: ${internships.length}');
  print('📋 Available internship IDs: ${internships.map((i) => i.id).toList()}');
  
  final internship = internships.firstWhereOrNull((i) => i.id == internshipId);
  
  if (internship == null) {
    print('❌ Internship not found for ID: $internshipId');
  } else {
    print('✅ Found internship: ${internship.department} at ${internship.hospital}');
  }
  
  return internship;
});