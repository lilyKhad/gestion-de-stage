
class Usermodel {
  final String id;
  final String email;
  final String role; // Assuming 'role' is a String

  Usermodel({
    required this.id,
    required this.email,
    required this.role,
  });

  // Create a Usermodel from a JSON map (e.g., data fetched from Firestore)
  factory Usermodel.fromJson(Map<String, dynamic> json) {
    // We use type casting and null checks to ensure the data is safe.
    // If the data comes from Firestore, the Document ID is often passed separately, 
    // but here we assume 'id' is a field in the map for simplicity.
    return Usermodel(
      id: json['id'] as String,
      email: json['email'] as String,
      role: json['role'] as String, // Ensure role is cast to String
    );
  }

  // Convert Usermodel to JSON map (e.g., data to be uploaded to Firestore)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      // You may choose not to upload the 'id' field if you use the 
      // Firestore Document ID as the user's ID.
    };
  }
}