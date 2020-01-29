import 'package:equatable/equatable.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';

class ArtworkToReturn extends Equatable {
  final String tag;
  final Artwork artwork;
  final String message;

  ArtworkToReturn({
    this.tag,
    this.artwork,
    this.message,
  });

  @override
  List<Object> get props => [
        tag,
        artwork,
        message,
      ];
}
