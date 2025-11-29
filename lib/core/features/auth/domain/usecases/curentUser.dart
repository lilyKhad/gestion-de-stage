

import 'package:med/core/features/auth/domain/entities/user.dart';
import 'package:med/core/features/auth/domain/repositories/auth_repository.dart';


class Currentuser {
  final AuthRepository repository;

  Currentuser({required this.repository});
  Future<UserEntity?> currentUser(){
    return repository.currentUser();
  }
}