import 'package:med/features/auth/domain/repositories/auth_repository.dart';

class Logout {
  final AuthRepository repository;

 Logout({required this.repository});
  Future<void>logOut(){
    return repository.logout();
  }
}