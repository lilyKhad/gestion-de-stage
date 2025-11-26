// entities/internship.dart
class Internship {
  final String id;
  final String department;
  final String doctorName;
  final String hospital;
  final DateTime startDate;
  final String? notes;

  Internship({
    required this.id,
    required this.department,
    required this.doctorName,
    required this.hospital,
    required this.startDate,
    this.notes,
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
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Internship &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}