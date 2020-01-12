import 'package:equatable/equatable.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:meta/meta.dart';

abstract class ArtworkUploadState extends Equatable {
  const ArtworkUploadState();
}

class ArtworkUploadInitial extends ArtworkUploadState {
  final Artwork artwork;

  ArtworkUploadInitial({
    this.artwork,
  });

  @override
  List<Object> get props => [artwork];
}

class ArtworkUploadLoading extends ArtworkUploadState {
  final String message;

  ArtworkUploadLoading({
    this.message,
  });

  @override
  List<Object> get props => null;
}

class ArtworkUploadError extends ArtworkUploadState {
  final String message;

  ArtworkUploadError({
    this.message,
  });

  @override
  List<Object> get props => [message];
}

class ArtworkUploadSuccess extends ArtworkUploadState {
  final Artwork artwork;
  final String message;

  ArtworkUploadSuccess({
    @required this.artwork,
    @required this.message,
  });

  @override
  List<Object> get props => [
        artwork,
        message,
      ];
}

class ArtworkDeleteSuccess extends ArtworkUploadState {
  final int artId;

  ArtworkDeleteSuccess({
    this.artId,
  });

  @override
  List<Object> get props => null;
}

class ImageHostSuccess extends ArtworkUploadState {
  final String imageUrl;

  ImageHostSuccess({
    @required this.imageUrl,
  });

  @override
  List<Object> get props => [imageUrl];
}

class EditArtworkInitialState extends ArtworkUploadState {
  final Artwork artwork;

  EditArtworkInitialState({
    @required this.artwork,
  });

  @override
  List<Object> get props => [
        artwork,
      ];
}
