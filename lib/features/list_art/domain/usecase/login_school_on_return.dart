import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:student_art_collection/core/domain/usecase/usecase.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/features/list_art/domain/repository/school_auth_repository.dart';

class LoginSchoolOnReturn implements UseCase<bool, Void> {
  final SchoolAuthRepository schoolAuthRepository;

  LoginSchoolOnReturn(this.schoolAuthRepository);

  @override
  Future<Either<Failure, bool>> call(Void params) {}
}
