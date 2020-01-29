import 'package:dartz/dartz.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/domain/usecase/usecase.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/features/list_art/domain/repository/school_artwork_repository.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/upload_artwork.dart';

class UpdateArtwork implements UseCase<Artwork, ArtworkToUpload> {
  final SchoolArtworkRepository repository;

  UpdateArtwork(this.repository);

  @override
  Future<Either<Failure, Artwork>> call(ArtworkToUpload params) async {
    return await repository.updateArtwork(params);
  }
}
