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

  ArtworkUploadSuccess({
    @required this.artwork,
  });

  @override
  List<Object> get props => null;
}
