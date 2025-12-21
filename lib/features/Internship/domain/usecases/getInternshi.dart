import 'package:med/features/Internship/domain/entity/internship.dart';
import 'package:med/features/Internship/domain/repository/internship_repo.dart';

class GetInternshipsUseCase {
  final InternshipRepository repository;

  GetInternshipsUseCase(this.repository);

  Future<List<Internship>> call() async {
    return await repository.getInternships();
  }
}
