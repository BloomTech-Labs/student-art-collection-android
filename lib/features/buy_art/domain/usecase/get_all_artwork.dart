
import 'package:dartz/dartz.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/domain/usecase/usecase.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/features/buy_art/domain/repository/buyer_artwork_repository.dart';

class GetAllArtwork implements UseCase<List<Artwork>, NoParams> {
  final BuyerArtworkRepository artworkRepository;

  GetAllArtwork(this.artworkRepository);

  @override
  Future<Either<Failure, List<Artwork>>> call(NoParams params) async {
    return await artworkRepository.getAllArtwork();
  }
}