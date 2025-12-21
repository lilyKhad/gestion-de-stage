// features/auth/domain/entities/user.dart
class UserEntity {
  final String id;
  final String email;
  final String role; // 'student', 'doctor', 'admin', etc.

  UserEntity({
    required this.id,
    required this.email,
    required this.role,
  });
}

