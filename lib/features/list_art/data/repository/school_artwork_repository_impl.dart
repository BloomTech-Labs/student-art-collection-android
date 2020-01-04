import 'package:dartz/dartz.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/features/list_art/domain/repository/school_artwork_repository.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/get_all_school_art.dart';

class SchoolAuthRepositoryImpl implements SchoolArtworkRepository {
  @override
  Future<Either<Failure, List<Artwork>>> getArtworkForSchool(
      SchoolId schoolId) {
    // TODO: implement getArtworkForSchool
    return null;
  }

  @override
  Future<Either<Failure, Artwork>> uploadArtwork(Artwork artwork) {
    // TODO: implement uploadArtwork
    return null;
  }
}
