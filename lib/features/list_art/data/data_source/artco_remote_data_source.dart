import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/login_school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/register_new_school.dart';

abstract class ArtcoRemoteDataSource {
  Future<School> registerNewSchool(SchoolToRegister schoolToRegister);

  Future<School> loginSchool(Credentials credentials);
}

class GraphQLRemoteDataSource implements ArtcoRemoteDataSource {
  @override
  Future<School> loginSchool(Credentials credentials) {
    // TODO: implement loginSchool
    return null;
  }

  @override
  Future<School> registerNewSchool(SchoolToRegister schoolToRegister) {
    // TODO: implement registerNewSchool
    return null;
  }
}
