
import 'package:med/features/Internship/domain/entity/internship.dart';

import '../repository/internship_repo.dart';

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
