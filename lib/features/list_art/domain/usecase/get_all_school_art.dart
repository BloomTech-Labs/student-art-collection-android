import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:student_art_collection/core/domain/usecase/usecase.dart';
import 'package:student_art_collection/core/error/failure.dart';

class GetAllSchoolArt implements UseCase<School, SchoolId> {
  @override
  Future<Either<Failure, School>> call(SchoolId params) {
    return null;
  }
}

class SchoolId extends Equatable {
  final String schoolId;

  SchoolId({this.schoolId});

  @override
  List<Object> get props => [schoolId];
}
