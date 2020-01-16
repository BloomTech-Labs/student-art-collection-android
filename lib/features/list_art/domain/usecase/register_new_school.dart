import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:student_art_collection/core/domain/usecase/usecase.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/features/list_art/domain/repository/school_auth_repository.dart';

class RegisterNewSchool implements UseCase<School, SchoolToRegister> {
  final SchoolAuthRepository schoolAuthRepository;

  RegisterNewSchool(this.schoolAuthRepository);

  @override
  Future<Either<Failure, School>> call(SchoolToRegister params) {
    return schoolAuthRepository.registerNewSchool(params);
  }
}

class SchoolToRegister {
  String schoolId;
  String email;
  String password;
  String schoolName;
  String address;
  String city;
  String state;
  String zipcode;

  SchoolToRegister({
    this.schoolId,
    @required this.email,
    @required this.password,
    @required this.schoolName,
    @required this.address,
    @required this.city,
    @required this.state,
    @required this.zipcode,
  });
}
