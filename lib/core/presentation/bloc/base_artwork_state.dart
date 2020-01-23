import 'package:equatable/equatable.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:meta/meta.dart';

abstract class GalleryState extends Equatable {
  const GalleryState();
}

class GalleryInitialState extends GalleryState {
  const GalleryInitialState();

  @override
  List<Object> get props => null;
}

class GalleryLoadingState extends GalleryState {
  const GalleryLoadingState();

  @override
  List<Object> get props => null;
}

class GalleryLoadedState extends GalleryState {
  final List<Artwork> artworkList;
  const GalleryLoadedState(this.artworkList);

  @override
  List<Object> get props => [artworkList];
}

class GalleryErrorState extends GalleryState {
  final String message;
  const GalleryErrorState({@required this.message});

  @override
  List<Object> get props => [message];
}

class Unauthorized extends GalleryState {
  @override
  List<Object> get props => null;
}
