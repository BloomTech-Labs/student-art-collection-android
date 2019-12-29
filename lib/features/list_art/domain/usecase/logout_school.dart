import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:student_art_collection/core/domain/usecase/usecase.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/features/list_art/domain/repository/school_auth_repository.dart';

class LogoutSchool implements UseCase<bool, NoParams> {
  final SchoolAuthRepository schoolAuthRepository;

  LogoutSchool(this.schoolAuthRepository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return schoolAuthRepository.logoutSchool();
  }
}
