import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med/core/features/Condidature/data/datasource/remotedata.dart';
import 'package:med/core/features/Condidature/data/repository/condidature_RepositoryImpl.dart';
import 'package:med/core/features/Condidature/domain/entity/condidature.dart';
import 'package:med/core/features/Condidature/domain/usecases/add_condidature.dart';
import 'package:med/core/features/Condidature/domain/usecases/GetCondidaturesByDepartmentUseCase.dart';
import 'package:med/core/features/Condidature/domain/usecases/GetCondidaturesByInternshipUseCase.dart';
import 'package:med/core/features/Condidature/domain/usecases/GetCondidaturesByStudentUseCase.dart';
import 'package:med/core/features/Internship/domain/entity/internship.dart';

// Firebase
final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

// Remote Data Source
final condidatureRemoteDataSourceProvider = Provider<CondidatureRemoteDataSource>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return CondidatureRemoteDataSource(firestore);
});

// Repository
final condidatureRepositoryProvider = Provider<CondidatureRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(condidatureRemoteDataSourceProvider);
  return CondidatureRepositoryImpl(remoteDataSource);
});

// Use Cases
final addCondidatureUseCaseProvider = Provider<AddCondidatureUseCase>((ref) {
  final repository = ref.watch(condidatureRepositoryProvider);
  return AddCondidatureUseCase(repository);
});

final getCondidaturesByStudentUseCaseProvider = Provider<GetCondidaturesByStudentUseCase>((ref) {
  final repository = ref.watch(condidatureRepositoryProvider);
  return GetCondidaturesByStudentUseCase(repository);
});

final getCondidaturesByInternshipUseCaseProvider = Provider<GetCondidaturesByInternshipUseCase>((ref) {
  final repository = ref.watch(condidatureRepositoryProvider);
  return GetCondidaturesByInternshipUseCase(repository);
});

final getCondidaturesByDepartmentUseCaseProvider = Provider<GetCondidaturesByDepartmentUseCase>((ref) {
  final repository = ref.watch(condidatureRepositoryProvider);
  return GetCondidaturesByDepartmentUseCase(repository);
});

// FutureProviders pour UI
final condidaturesByStudentProvider = FutureProvider.family<List<CondidatureEntity>, String>((ref, studentId) async {
  final useCase = ref.read(getCondidaturesByStudentUseCaseProvider);
  return await useCase(studentId);
});

final condidaturesByInternshipProvider = FutureProvider.family<List<CondidatureEntity>, String>((ref, internshipId) async {
  final useCase = ref.read(getCondidaturesByInternshipUseCaseProvider);
  return await useCase(internshipId);
});

final condidaturesByDepartmentProvider = FutureProvider.family<List<CondidatureEntity>, String>((ref, department) async {
  final useCase = ref.read(getCondidaturesByDepartmentUseCaseProvider);
  return await useCase(department);
});

// FutureProvider pour ajouter une condidature
final addCondidatureProvider = FutureProvider.family<void, CondidatureEntity>((ref, condidature) async {
  final useCase = ref.read(addCondidatureUseCaseProvider);
  await useCase(condidature);
});

final getCondidatureProvider = FutureProvider.family<CondidatureEntity?, String>((ref, internshipId) async {
  final useCase = ref.watch(getCondidaturesByInternshipUseCaseProvider);
  final condidatures = await useCase(internshipId);
  if (condidatures.isEmpty) return null;
  return condidatures.first; // return the first condidature for this internship
});