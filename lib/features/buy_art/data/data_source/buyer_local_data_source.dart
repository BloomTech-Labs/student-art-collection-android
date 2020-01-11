import 'package:student_art_collection/core/domain/entity/artwork.dart';

abstract class BuyerLocalDataSource{

  /// Gets the cached List of [Artwork] which was gotten the last time
  /// the user had made a search for artwork
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<List<Artwork>> getLastArtworkList();

  Future<Artwork> getArtworkById(int id);

  Future<void> cacheArtworkList(List<Artwork> artworkToCache);

  Future<void> cacheArtwork(Artwork artworkToCache);
}

class BuyerLocalDataSourceImpl implements BuyerLocalDataSource{
  @override
  Future<void> cacheArtwork(Artwork artworkToCache) {
    // TODO: implement cacheArtwork
    return null;
  }

  @override
  Future<void> cacheArtworkList(List<Artwork> artworkToCache) {
    // TODO: implement cacheArtworkList
    return null;
  }

  @override
  Future<Artwork> getArtworkById(int id) {
    // TODO: implement getArtworkById
    return null;
  }

  @override
  Future<List<Artwork>> getLastArtworkList() {
    // TODO: implement getLastArtworkList
    return null;
  }

}