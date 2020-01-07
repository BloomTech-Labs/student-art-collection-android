import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:student_art_collection/core/domain/usecase/usecase.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/features/list_art/domain/repository/school_artwork_repository.dart';
import 'package:meta/meta.dart';

class GetAllSchoolArt implements UseCase<List<Artwork>, SchoolId> {
  final SchoolArtworkRepository repository;

  GetAllSchoolArt(this.repository);

  @override
  Future<Either<Failure, List<Artwork>>> call(SchoolId params) {
    return repository.getArtworkForSchool(params);
  }
}

class SchoolId extends Equatable {
  final int schoolId;

  SchoolId({this.schoolId});

  @override
  List<Object> get props => [schoolId];
}
