import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med/core/features/etudiant/data/Models/student_model.dart';
import 'package:flutter/foundation.dart'; // for debugPrint


class StudentRemoteDataSource {
  final FirebaseFirestore firestore;

  StudentRemoteDataSource(this.firestore);

  /// Fetch student
  Future<StudentModel?> getStudent(String studentId) async {
    debugPrint('📌 getStudent called: $studentId');
    try {
      final doc = await firestore.collection('users').doc(studentId).get();
      if (!doc.exists) return null;

      final student = StudentModel.fromMap(doc.data()!);
      debugPrint('📌 Student fetched: $student');
      return student;
    } catch (e) {
      debugPrint('❌ Error fetching student: $e');
      return null;
    }
  }

  /// Update profile picture (Google Drive link)
  Future<void> updateProfilePicture(String studentId, String photoUrl) async {
    debugPrint('📌 Updating profile picture for $studentId with $photoUrl');
    try {
      await firestore.collection('users').doc(studentId).update({
        'photoUrl': photoUrl,
      });
    } catch (e) {
      debugPrint('❌ Error updating profile picture: $e');
      rethrow;
    }
  }

  /// Add a document link (Google Drive link)
  Future<void> uploadDocument(String studentId, String documentUrl) async {
    debugPrint('📌 Uploading document for $studentId: $documentUrl');
    try {
      final docRef = firestore.collection('users').doc(studentId);
      await docRef.update({
        'documents': FieldValue.arrayUnion([documentUrl]),
      });
    } catch (e) {
      debugPrint('❌ Error uploading document: $e');
      rethrow;
    }
  }

  /// Remove a document link
  Future<void> deleteDocument(String studentId, String documentUrl) async {
    debugPrint('📌 Deleting document for $studentId: $documentUrl');
    try {
      final docRef = firestore.collection('users').doc(studentId);
      await docRef.update({
        'documents': FieldValue.arrayRemove([documentUrl]),
      });
    } catch (e) {
      debugPrint('❌ Error deleting document: $e');
      rethrow;
    }
  }

  /// Get all document links
  Future<List<String>> getStudentDocuments(String studentId) async {
    debugPrint('📌 Getting documents for $studentId');
    try {
      final doc = await firestore.collection('users').doc(studentId).get();
      if (!doc.exists) return [];
      return List<String>.from(doc.data()?['documents'] ?? []);
    } catch (e) {
      debugPrint('❌ Error fetching documents: $e');
      return [];
    }
  }
}
