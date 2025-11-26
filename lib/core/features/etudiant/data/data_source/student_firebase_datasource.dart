// lib/data/datasources/student_firebase_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:med/core/features/etudiant/data/Models/student_model.dart';
import 'dart:io';

abstract class StudentFirebaseDataSource {
  Future<StudentModel> getStudent(String studentId);
  Future<StudentModel> updateStudent(StudentModel student);
  Future<String> uploadPhoto(String studentId, File photoFile);
  Future<String> uploadDocument(String studentId, File documentFile, String documentType);
  Future<void> deleteDocument(String studentId, String documentId);
  Future<List<String>> getStudentDocuments(String studentId);
}

class StudentFirebaseDataSourceImpl implements StudentFirebaseDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  StudentFirebaseDataSourceImpl({
    required this.firestore,
    required this.storage,
  });

  @override
  Future<StudentModel> getStudent(String studentId) async {
    final doc = await firestore.collection('users').doc(studentId).get();
    
    if (doc.exists) {
      return StudentModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    } else {
      throw Exception('Student not found');
    }
  }

  @override
  Future<StudentModel> updateStudent(StudentModel student) async {
    await firestore.collection('users').doc(student.id).update(student.toJson());
    return student;
  }

  @override
  Future<String> uploadPhoto(String studentId, File photoFile) async {
    final ref = storage.ref().child('students/$studentId/profile_photo/${DateTime.now().millisecondsSinceEpoch}');
    final uploadTask = await ref.putFile(photoFile);
    final downloadUrl = await uploadTask.ref.getDownloadURL();
    
    // Update student's photo URL in Firestore
    await firestore.collection('users').doc(studentId).update({'photoUrl': downloadUrl});
    
    return downloadUrl;
  }

  @override
  Future<String> uploadDocument(String studentId, File documentFile, String documentType) async {
    final ref = storage.ref().child('students/$studentId/documents/${DateTime.now().millisecondsSinceEpoch}_$documentType');
    final uploadTask = await ref.putFile(documentFile);
    final downloadUrl = await uploadTask.ref.getDownloadURL();
    
    // Add document to student's documents list in Firestore
    final studentDoc = await firestore.collection('users').doc(studentId).get();
    if (studentDoc.exists) {
      final student = StudentModel.fromJson(studentDoc.data() as Map<String, dynamic>, studentId);
      final updatedDocuments = List<String>.from(student.documents)..add(downloadUrl);
      await firestore.collection('users').doc(studentId).update({'documents': updatedDocuments});
    }
    
    return downloadUrl;
  }

  @override
  Future<void> deleteDocument(String studentId, String documentId) async {
    // Remove from storage
    try {
      await storage.refFromURL(documentId).delete();
    } catch (e) {
      // Document might not exist in storage, continue with Firestore update
    }
    
    // Remove from student's documents list in Firestore
    final studentDoc = await firestore.collection('users').doc(studentId).get();
    if (studentDoc.exists) {
      final student = StudentModel.fromJson(studentDoc.data() as Map<String, dynamic>, studentId);
      final updatedDocuments = List<String>.from(student.documents)..remove(documentId);
      await firestore.collection('users').doc(studentId).update({'documents': updatedDocuments});
    }
  }

  @override
  Future<List<String>> getStudentDocuments(String studentId) async {
    final doc = await firestore.collection('users').doc(studentId).get();
    
    if (doc.exists) {
      final student = StudentModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      return student.documents;
    } else {
      throw Exception('Student not found');
    }
  }
}