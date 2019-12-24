import 'package:student_art_collection/core/data/model/artwork_model.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';

abstract class ArtworkRemoteDataSource{

  /// Throws a [ServerException] for all error codes
  Future <List<ArtworkModel>> getAllArtwork();

  /// Throws a [ServerException] for all error codes
  Future <ArtworkModel> getArtworkById(int id);
}