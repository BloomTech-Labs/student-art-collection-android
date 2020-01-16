import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:student_art_collection/core/domain/usecase/usecase.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:meta/meta.dart';
import 'package:student_art_collection/features/list_art/domain/repository/school_auth_repository.dart';

class LoginSchool implements UseCase<School, Credentials> {
  final SchoolAuthRepository schoolAuthRepository;

  LoginSchool(this.schoolAuthRepository);

  @override
  Future<Either<Failure, School>> call(Credentials params) {
    return schoolAuthRepository.loginSchool(params);
  }
}

class Credentials extends Equatable {
  final String email;
  final String password;
  final bool shouldRemember;

  Credentials({
    @required this.email,
    @required this.password,
    this.shouldRemember = false,
  });

  @override
  List<Object> get props => [email, password];
}
