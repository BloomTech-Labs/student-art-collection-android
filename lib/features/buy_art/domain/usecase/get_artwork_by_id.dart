import 'package:dartz/dartz.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/domain/usecase/usecase.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/features/buy_art/domain/repository/artwork_repository.dart';

class GetArtworkByID implements UseCase<Artwork, int> {
  final ArtworkRepository artworkRepository;

  GetArtworkByID(this.artworkRepository);

  @override
  Future<Either<Failure, Artwork>> call(int artworkID)async {
    return await artworkRepository.getArtworkById(artworkID);
  }
}