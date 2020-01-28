import 'package:dartz/dartz.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:student_art_collection/core/domain/usecase/usecase.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/features/list_art/domain/repository/school_auth_repository.dart';
import 'package:meta/meta.dart';

class UpdateSchoolInfo implements UseCase<School, SchoolToUpdate> {
  final SchoolAuthRepository schoolAuthRepository;

  UpdateSchoolInfo(this.schoolAuthRepository);

  @override
  Future<Either<Failure, School>> call(SchoolToUpdate params) {
    return schoolAuthRepository.updateSchoolInfo(params);
  }
}

class SchoolToUpdate {
  String email;
  String id;
  String schoolName;
  String address;
  String city;
  String state;
  String zipcode;

  SchoolToUpdate({
    @required this.email,
    @required this.id,
    @required this.schoolName,
    @required this.address,
    @required this.city,
    @required this.state,
    @required this.zipcode,
  });
}
