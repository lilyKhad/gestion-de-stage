// data/datasource/remotedata/condidature_remote_data_source.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med/core/features/Condidature/domain/entity/condidature.dart';



import 'package:cloud_firestore/cloud_firestore.dart';

class CondidatureRemoteDataSource {
  final FirebaseFirestore firestore;

  CondidatureRemoteDataSource(this.firestore);

  // ✅ Case-insensitive lookup
  Future<CondidatureEntity?> getCondidatureByInternship(String internshipId) async {
    try {
      print('🔍 Searching for condidature with internshipId: "$internshipId"');

      final allDocs = await firestore.collection('Condidature').get();
      print('📊 Total documents in Condidature collection: ${allDocs.docs.length}');

      final matchingDoc = allDocs.docs.firstWhere(
        (doc) {
          final docInternshipId = (doc.data()['internshipId'] ?? '').toString().trim();
          return docInternshipId.toLowerCase() == internshipId.toLowerCase();
        },
        
      );

      if (matchingDoc == null) {
        print('❌ No condidature found for internship: "$internshipId"');
        return null;
      }

      final data = matchingDoc.data();
      print('✅ Found condidature: ${matchingDoc.id}');

      return CondidatureEntity.fromMap(data);
    } catch (e) {
      print('❌ Error getting condidature: $e');
      return null;
    }
  }

  Future<void> addCondidature(CondidatureEntity condidature) async {
    try {
      await firestore
          .collection('Condidature')
          .doc(condidature.id)
          .set(condidature.toMap());

      print('✅ Condidature added successfully');
    } catch (e) {
      print('❌ Error adding condidature: $e');
      rethrow;
    }
  }
}
