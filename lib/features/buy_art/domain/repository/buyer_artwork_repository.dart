
import 'package:dartz/dartz.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/error/failure.dart';

abstract class ArtworkRepository{
  Future <Either<Failure, List<Artwork>>> getAllArtwork();
  Future <Either<Failure, Artwork>> getArtworkById(int id);
}