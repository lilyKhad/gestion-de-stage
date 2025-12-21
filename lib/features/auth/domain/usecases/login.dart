import 'package:dartz/dartz.dart';
import 'package:med/core/errors/failures.dart';
import 'package:med/features/auth/domain/entities/user.dart';
import 'package:med/features/auth/domain/repositories/auth_repository.dart';

class Login {
  final AuthRepository repository;

  Login({required this.repository});

  Future<Either<Failure, UserEntity>> logIn({
    required String email,
    required String password,
  }) {
    return repository.login(email: email, password: password);
  }
}
