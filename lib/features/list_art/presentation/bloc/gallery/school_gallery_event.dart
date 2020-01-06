import 'package:equatable/equatable.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_event.dart';

abstract class SchoolGalleryEvent extends Equatable {
  const SchoolGalleryEvent();
}

class GetAllSchoolArtworkEvent extends SchoolAuthEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}
