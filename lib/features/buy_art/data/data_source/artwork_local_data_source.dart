import 'package:student_art_collection/core/data/model/artwork_model.dart';

abstract class ArtworkLocalDataSource{

  /// Gets the cached List of [ArtworkModel] which was gotten the last time
  /// the user had made a search for artwork
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<List<ArtworkModel>> getLastArtworkList();

  Future<ArtworkModel> getArtworkById(int id);

  Future<void> cacheArtworkList(List<ArtworkModel> artworkToCache);

  Future<void> cacheArtwork(ArtworkModel artworkToCache);
}