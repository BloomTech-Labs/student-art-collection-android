import 'package:equatable/equatable.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';

abstract class SchoolGalleryState extends Equatable {
  const SchoolGalleryState();
}

class Empty extends SchoolGalleryState {
  @override
  List<Object> get props => [];
}

class Loading extends SchoolGalleryState {
  @override
  List<Object> get props => null;
}

class Error extends SchoolGalleryState {
  final String message;

  Error({this.message});

  @override
  List<Object> get props => [message];
}

class Loaded extends SchoolGalleryState {
  final List<Artwork> artworks;

  Loaded({this.artworks});

  @override
  List<Object> get props => [artworks];
}
