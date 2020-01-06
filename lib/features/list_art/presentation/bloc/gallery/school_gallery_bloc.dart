import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/gallery/school_gallery_event.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/gallery/school_gallery_state.dart';

class SchoolGalleryBloc extends Bloc<SchoolGalleryEvent, SchoolGalleryState> {
  @override
  SchoolGalleryState get initialState => InitialSchoolGalleryState();

  @override
  Stream<SchoolGalleryState> mapEventToState(
    SchoolGalleryEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
