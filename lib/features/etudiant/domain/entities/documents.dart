class StudentDocument {
  final String fileName;
  final String fileData; // This is the Base64 string
  final String fileType; // pdf, image, etc.
  final DateTime uploadedAt;

  const StudentDocument({
    required this.fileName,
    required this.fileData,
    required this.fileType,
    required this.uploadedAt,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'fileName': fileName,
      'fileData': fileData,
      'fileType': fileType,
      'uploadedAt': uploadedAt.millisecondsSinceEpoch,
    };
  }

  // Create from Map (from Firestore)
  factory StudentDocument.fromMap(Map<String, dynamic> map) {
    return StudentDocument(
      fileName: map['fileName'] ?? '',
      fileData: map['fileData'] ?? '',
      fileType: map['fileType'] ?? '',
      uploadedAt: map['uploadedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['uploadedAt'])
          : DateTime.now(),
    );
  }
}