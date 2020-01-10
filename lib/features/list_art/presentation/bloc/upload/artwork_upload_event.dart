import 'package:equatable/equatable.dart';

abstract class ArtworkUploadEvent extends Equatable {
  const ArtworkUploadEvent();
}

class UploadNewArtworkEvent extends ArtworkUploadEvent {
  final int category, price;
  final bool sold;
  final String title, artistName, description;
  final List<String> imageUrls;

  UploadNewArtworkEvent({
    this.category,
    this.price,
    this.sold,
    this.title,
    this.artistName,
    this.description,
    this.imageUrls,
  });

  @override
  List<Object> get props => [
        category,
        price,
        sold,
        title,
        artistName,
        description,
        imageUrls,
      ];
}

class ImageHostEvent extends
