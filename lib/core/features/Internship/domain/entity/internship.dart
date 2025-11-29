class Internship {
  final String id;
  final String department;
  final String doctorName;
  final String hospital;
  final DateTime startDate;
  final String? notes;
  final String duree;
  final String? pictureUrl; // New field for image

  Internship({
    required this.id,
    required this.department,
    required this.doctorName,
    required this.hospital,
    required this.startDate,
    required this.duree,
    this.notes,
    this.pictureUrl, // Can be null if no picture
  });

  // Convert to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'department': department,
      'doctorName': doctorName,
      'hospital': hospital,
      'startDate': startDate.millisecondsSinceEpoch,
      'notes': notes,
      'duree': duree,
      'pictureUrl': pictureUrl, // Include picture URL
    };
  }

  // Create from Firebase document
  factory Internship.fromMap(Map<String, dynamic> map) {
    return Internship(
      id: map['id'] ?? '',
      department: map['department'] ?? '',
      doctorName: map['doctorName'] ?? '',
      hospital: map['hospital'] ?? '',
      startDate: DateTime.fromMillisecondsSinceEpoch(
        map['startDate'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      notes: map['notes'],
      duree: map['duree'] ?? '',
      pictureUrl: map['pictureUrl'], // Can be null
    );
  }

  // Copy with method for easy updates
  Internship copyWith({
    String? id,
    String? department,
    String? doctorName,
    String? hospital,
    DateTime? startDate,
    String? duree,
    String? notes,
    String? pictureUrl,
  }) {
    return Internship(
      id: id ?? this.id,
      department: department ?? this.department,
      doctorName: doctorName ?? this.doctorName,
      hospital: hospital ?? this.hospital,
      startDate: startDate ?? this.startDate,
      duree: duree ?? this.duree,
      notes: notes ?? this.notes,
      pictureUrl: pictureUrl ?? this.pictureUrl,
    );
  }

  // Helper method to check if internship has a valid picture
  bool get hasPicture => pictureUrl != null && pictureUrl!.isNotEmpty;

  // Helper method to get a default image based on department
  String get defaultImage {
    switch (department.toLowerCase()) {
      case 'cardiology':
      case 'cardiologie':
        return 'assets/cardiology_default.jpg';
      case 'neurology':
      case 'neurologie':
        return 'assets/neurology_default.jpg';
      case 'surgery':
      case 'chirurgie':
        return 'assets/surgery_default.jpg';
      case 'pediatrics':
      case 'pediatrie':
        return 'assets/pediatrics_default.jpg';
      default:
        return 'assets/hospital_default.jpg';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Internship &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Internship{id: $id, department: $department, doctorName: $doctorName, hospital: $hospital, startDate: $startDate, duree: $duree, notes: $notes, pictureUrl: $pictureUrl}';
  }
}