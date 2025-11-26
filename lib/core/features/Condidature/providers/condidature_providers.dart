// application/condidature_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med/core/features/Condidature/data/datasource/remotedata.dart';
import 'package:med/core/features/Condidature/data/repository/condidature_repositoryImpl.dart';
import 'package:med/core/features/Condidature/domain/entity/condidature.dart';
import 'package:med/core/features/Condidature/domain/usecases/add_usecase.dart';
import 'package:med/core/features/Condidature/domain/usecases/get_usecase.dart';


// Firebase Provider
final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

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
final getCondidatureUseCaseProvider = Provider<GetCondidatureUseCase>((ref) {
  final repository = ref.watch(condidatureRepositoryProvider);
  return GetCondidatureUseCase(repository);
});

final addCondidatureUseCaseProvider = Provider<AddCondidatureUseCase>((ref) {
  final repository = ref.watch(condidatureRepositoryProvider);
  return AddCondidatureUseCase(repository);
});
final getCondidatureProvider = FutureProvider.family<CondidatureEntity?, String>(
  (ref, internshipId) async {
    final useCase = ref.read(getCondidatureUseCaseProvider);
    return await useCase(internshipId);
  },
);