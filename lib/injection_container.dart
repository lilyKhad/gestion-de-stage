// // lib/injection_container.dart

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:get_it/get_it.dart';

// // ------------------------- Étudiant -------------------------
// import 'package:med/core/features/etudiant/data/data_source/student_firebase_datasource.dart';
// import 'package:med/core/features/etudiant/data/repository/student_repository_impl.dart';
// import 'package:med/core/features/etudiant/domain/repositories/etudiant_repository.dart';
// import 'package:med/core/features/etudiant/domain/usecases/etudiant_usecase.dart';
// import 'package:med/core/features/etudiant/domain/usecases/upload_document_usecase.dart';
// import 'package:med/core/features/etudiant/domain/usecases/upload_photo_usecase.dart';

// // ------------------------- Stage -------------------------
// import 'package:med/core/features/stage/data/datasources/remote_dataSources/internship_firebase_datasource.dart';
// import 'package:med/core/features/stage/data/repository/internship_repository_impl.dart';
// import 'package:med/core/features/stage/domaine/repositories/stage_repository.dart';
// import 'package:med/core/features/stage/domaine/usecases/get_all_internships_usecase.dart';
// import 'package:med/core/features/stage/domaine/usecases/get_filtered_internships_usecase.dart';
// import 'package:med/core/features/stage/domaine/usecases/search_internships_usecase.dart';

// final sl = GetIt.instance;

// Future<void> init() async {
//   // ------------------------- External -------------------------
//   sl.registerLazySingleton(() => FirebaseFirestore.instance);
//   sl.registerLazySingleton(() => FirebaseStorage.instance);
//   sl.registerLazySingleton(() => Connectivity());

//   // ------------------------- Core -------------------------
//   sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

//   // ------------------------- Data Sources -------------------------
//   sl.registerLazySingleton<StudentFirebaseDataSource>(
//     () => StudentFirebaseDataSourceImpl(
//       firestore: sl(),
//       storage: sl(),
//     ),
//   );

//   sl.registerLazySingleton<InternshipFirebaseDataSource>(
//     () => InternshipFirebaseDataSourceImpl(
//       firestore: sl(),
//     ),
//   );

//   // ------------------------- Repositories -------------------------
//   sl.registerLazySingleton<StudentRepository>(
//     () => StudentRepositoryImpl(dataSource: sl()),
//   );

//   sl.registerLazySingleton<InternshipRepository>(
//     () => InternshipRepositoryImpl(dataSource: sl()),
//   );

//   // ------------------------- Use Cases: Étudiant -------------------------
//   sl.registerLazySingleton(() => UpdateStudentUseCase(sl()));
//   sl.registerLazySingleton(() => UploadPhotoUseCase(sl()));
//   sl.registerLazySingleton(() => UploadDocumentUseCase(sl()));

//   // ------------------------- Use Cases: Stage -------------------------
//   sl.registerLazySingleton(() => GetAllInternshipsUseCase(sl()));
//   sl.registerLazySingleton(() => GetFilteredInternshipsUseCase(sl()));
//   sl.registerLazySingleton(() => SearchInternshipsUseCase(sl()));
// }

// // ------------------------- CORE -------------------------

// abstract class NetworkInfo {
//   Future<bool> get isConnected;
// }

// class NetworkInfoImpl implements NetworkInfo {
//   final Connectivity connectivity;

//   NetworkInfoImpl(this.connectivity);

//   @override
//   Future<bool> get isConnected async {
//     final result = await connectivity.checkConnectivity();
//     return result != ConnectivityResult.none;
//   }
// }
