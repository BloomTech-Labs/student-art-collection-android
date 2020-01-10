import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/domain/usecase/usecase.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/features/list_art/domain/repository/school_artwork_repository.dart';
import 'package:student_art_collection/features/list_art/domain/repository/school_auth_repository.dart';
import 'package:meta/meta.dart';

class UploadArtwork implements UseCase<Artwork, ArtworkToUpload> {
  final SchoolArtworkRepository repository;

  UploadArtwork(this.repository);

  @override
  Future<Either<Failure, Artwork>> call(ArtworkToUpload artworkToUpload) async {
    return await repository.uploadArtwork(artworkToUpload);
  }
}

class ArtworkToUpload extends Equatable {
  final int schoolId, category, price;
  final bool sold;
  final String title, artistName, description;
  final List<File> imagesToUpload;

  ArtworkToUpload({
    @required this.schoolId,
    this.category,
    @required this.price,
    @required this.sold,
    this.title,
    this.artistName,
    this.description,
    this.imagesToUpload,
  });

  @override
  List<Object> get props => [
        schoolId,
        category,
        price,
        sold,
        title,
        artistName,
        description,
        imagesToUpload,
      ];
}

class ImageToUpload extends Equatable {
  final String imageUrl;
  final int artId;

  ImageToUpload({
    this.artId,
    @required this.imageUrl,
  });

  @override
  List<Object> get props => [
        imageUrl,
      ];
}
