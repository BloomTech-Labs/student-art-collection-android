import 'package:dartz/dartz.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/domain/usecase/usecase.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/features/list_art/domain/repository/school_artwork_repository.dart';
import 'package:student_art_collection/features/list_art/domain/repository/school_auth_repository.dart';

class UploadArtwork implements UseCase<Artwork, Artwork> {
  final SchoolArtworkRepository repository;

  UploadArtwork(this.repository);

  @override
  Future<Either<Failure, Artwork>> call(Artwork artwork) async {
    return await repository.uploadArtwork(artwork);
  }
}
