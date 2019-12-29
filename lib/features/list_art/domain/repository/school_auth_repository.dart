import 'package:dartz/dartz.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/login_school.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/register_new_school.dart';

abstract class SchoolAuthRepository {
  Future<Either<Failure, School>> registerNewSchool(SchoolToRegister school);
  Future<Either<Failure, School>> loginSchool(Credentials credentials);
  Future<Either<Failure, bool>> logoutSchool();
  Future<Either<Failure, School>> loginSchoolOnReturn();
}
