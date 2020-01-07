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

class ArtworkLocalDataSourceImpl implements ArtworkLocalDataSource{
  @override
  Future<void> cacheArtwork(ArtworkModel artworkToCache) {
    // TODO: implement cacheArtwork
    return null;
  }

  @override
  Future<void> cacheArtworkList(List<ArtworkModel> artworkToCache) {
    // TODO: implement cacheArtworkList
    return null;
  }

  @override
  Future<ArtworkModel> getArtworkById(int id) {
    // TODO: implement getArtworkById
    return null;
  }

  @override
  Future<List<ArtworkModel>> getLastArtworkList() {
    // TODO: implement getLastArtworkList
    return null;
  }

}