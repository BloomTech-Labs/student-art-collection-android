import 'package:dartz/dartz.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/get_all_school_art.dart';

abstract class SchoolArtworkRepository {
  Future<Either<Failure, List<Artwork>>> getArtworkForSchool(SchoolId schoolId);
  Future<Either<Failure, Artwork>> uploadArtwork(Artwork artwork);
}
