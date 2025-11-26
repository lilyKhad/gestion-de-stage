// domain/usecases/search_internships_usecase.dart
import '../repository/internship_repo.dart';
import '../entity/internship.dart';

class SearchInternshipsUseCase {
  final InternshipRepository repository;

  SearchInternshipsUseCase(this.repository);

  Future<List<Internship>> call({String? department, String? doctorName}) async {
    return await repository.searchInternships(
      department: department,
      doctorName: doctorName,
    );
  }
}
