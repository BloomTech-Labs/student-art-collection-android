import 'package:equatable/equatable.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';

abstract class SchoolGalleryState extends Equatable {
  const SchoolGalleryState();
}

class SchoolGalleryEmpty extends SchoolGalleryState {
  @override
  List<Object> get props => [];
}

class SchoolGalleryLoading extends SchoolGalleryState {
  @override
  List<Object> get props => null;
}

class SchoolGalleryError extends SchoolGalleryState {
  final String message;

  SchoolGalleryError({this.message});

  @override
  List<Object> get props => [message];
}

class SchoolGalleryLoaded extends SchoolGalleryState {
  final List<Artwork> artworks;

  SchoolGalleryLoaded({this.artworks});

  @override
  List<Object> get props => [artworks];
}

class Unauthorized extends SchoolGalleryError {}
