import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';

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

class UpdateArtworkEvent extends ArtworkUploadEvent {
  final int category, price, artId;
  final bool sold;
  final String title, artistName, description;
  final List<String> imageUrls;

  UpdateArtworkEvent({
    this.artId,
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
        artId,
        category,
        price,
        sold,
        title,
        artistName,
        description,
        imageUrls,
      ];
}

class InitializeEditArtworkPageEvent extends ArtworkUploadEvent {
  final Artwork artwork;

  InitializeEditArtworkPageEvent({
    this.artwork,
  });

  @override
  List<Object> get props => [
        artwork,
      ];
}

class InitializeNewArtworkPageEvent extends ArtworkUploadEvent {
  @override
  List<Object> get props => null;
}

class HostImageEvent extends ArtworkUploadEvent {
  final File imageFileToHost;

  HostImageEvent({
    this.imageFileToHost,
  });

  @override
  List<Object> get props => [imageFileToHost];
}
