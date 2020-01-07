import 'package:equatable/equatable.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_event.dart';

abstract class SchoolGalleryEvent extends Equatable {
  const SchoolGalleryEvent();
}

class GetAllSchoolArtworkEvent extends SchoolGalleryEvent {
  @override
  List<Object> get props => null;
}

class UploadArtwork extends SchoolGalleryEvent {
  final Artwork artwork;

  UploadArtwork({
    this.artwork,
  });

  @override
  List<Object> get props => null;
}
