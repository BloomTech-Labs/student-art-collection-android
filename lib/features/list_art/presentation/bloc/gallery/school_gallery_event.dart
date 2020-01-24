import 'package:equatable/equatable.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/presentation/bloc/base_artwork_filter_type.dart';
import 'package:student_art_collection/core/presentation/bloc/base_artwork_sort_type.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_event.dart';

abstract class SchoolGalleryEvent extends Equatable {
  const SchoolGalleryEvent();
}

class GetAllSchoolArtworkEvent extends SchoolGalleryEvent {
  final SortType sortType;
  final List<FilterType> filterTypes;

  const GetAllSchoolArtworkEvent({
    this.sortType,
    this.filterTypes,
  });

  @override
  List<Object> get props => null;
}

class LogoutEvent extends SchoolGalleryEvent {
  @override
  List<Object> get props => null;
}
