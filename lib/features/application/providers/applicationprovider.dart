// Application Remote Data Source
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med/core/enums/statuts.dart';
import 'package:med/features/application/data/remotedata.dart';
import 'package:med/features/application/data/repository/app_repoImpl.dart';
import 'package:med/features/application/domain/entity/application.dart';
import 'package:med/features/application/domain/repository/application_repository.dart';
import 'package:med/features/application/domain/usecases/applicatio_usescases.dart';
import 'package:med/features/etudiant/providers/student_providers.dart';

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

final updateApplicationStatusProvider = FutureProvider.family<void, ({String applicationId, InternshipStatus status})>((ref, params) async {
  final useCase = ref.read(updateApplicationStatusUseCaseProvider);
  await useCase(params.applicationId, params.status);
});



// Import your ApplicationEntity and DashboardRowData files here

final doctorApplicationsProvider = FutureProvider.family<List<DashboardRowData>, String>((ref, doctorId) async {
  if (doctorId.isEmpty) return [];

  final firestore = FirebaseFirestore.instance;
  List<DashboardRowData> results = [];

  try {
    // STEP 1: Find all internships that belong to this Doctor
    final internshipsSnapshot = await firestore
        .collection('internships') 
        .where('doctorId', isEqualTo: doctorId)
        .get();

    if (internshipsSnapshot.docs.isEmpty) return [];

    // Map: InternshipID -> InternshipData
    Map<String, Map<String, dynamic>> internshipMap = {};
    for (var doc in internshipsSnapshot.docs) {
      internshipMap[doc.id] = doc.data();
    }
    
    List<String> internshipIds = internshipMap.keys.toList();

    // STEP 2: Fetch Applications (Chunked for safety)
    List<List<String>> chunks = [];
    for (var i = 0; i < internshipIds.length; i += 10) {
      chunks.add(internshipIds.sublist(i, i + 10 > internshipIds.length ? internshipIds.length : i + 10));
    }

    List<QueryDocumentSnapshot> allAppDocs = [];
    
    for (var chunk in chunks) {
      final chunkSnapshot = await firestore
          .collection('applications') 
          .where('internshipId', whereIn: chunk)
          .get();
      allAppDocs.addAll(chunkSnapshot.docs);
    }

    // STEP 3: Loop through applications and fetch Student details
    for (var doc in allAppDocs) {
      // 1. Convert Firestore doc to Entity
      final appEntity = ApplicationEntity.fromMap(doc.id, doc.data() as Map<String, dynamic>);

      // 2. Get Internship Data
      final internshipData = internshipMap[appEntity.internshipId] ?? {};
      final String hospitalName = internshipData['hospital'] ?? 'Hôpital Inconnu';
      
      DateTime endDate = appEntity.appliedAt.add(const Duration(days: 30));
      if (internshipData['date_fin'] != null) {
         endDate = (internshipData['date_fin'] as Timestamp).toDate();
      }

      // 3. Fetch Student Name
      String studentName = "Étudiant Inconnu";
      try {
        final studentDoc = await firestore.collection('users').doc(appEntity.studentId).get();
        if (studentDoc.exists) {
          final data = studentDoc.data();
          studentName = "${data?['nom'] ?? ''} ${data?['prenom'] ?? ''}".trim();
          if (studentName.isEmpty) studentName = data?['name'] ?? "Étudiant Inconnu";
        }
      } catch (e) {
        print("Error fetching student: $e");
      }

      // 4. Create the Row Data
      results.add(DashboardRowData(
        id: appEntity.id,
        studentId: appEntity.studentId, // <--- ADDED HERE (Taken from the entity)
        studentName: studentName.isEmpty ? "Sans Nom" : studentName,
        hospitalName: hospitalName,
        startDate: appEntity.appliedAt,
        endDate: endDate,
        status: appEntity.status.name, 
      ));
    }

  } catch (e) {
    print("Error in doctorApplicationsProvider: $e");
    return [];
  }

  return results;
});