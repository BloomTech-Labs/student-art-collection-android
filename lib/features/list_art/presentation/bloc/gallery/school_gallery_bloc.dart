import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:student_art_collection/core/domain/entity/school.dart';
import 'package:student_art_collection/core/session/session_manager.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/get_all_school_art.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_state.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/gallery/school_gallery_event.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/gallery/school_gallery_state.dart';
import 'package:meta/meta.dart';

class SchoolGalleryBloc extends Bloc<SchoolGalleryEvent, SchoolGalleryState> {
  final GetAllSchoolArt getAllSchoolArt;
  final SessionManager sessionManager;

  SchoolGalleryBloc({
    @required this.getAllSchoolArt,
    @required this.sessionManager,
  });

  @override
  SchoolGalleryState get initialState => Empty();

  @override
  Stream<SchoolGalleryState> mapEventToState(
    SchoolGalleryEvent event,
  ) async* {
    final currentUser = sessionManager.currentUser;
    if (currentUser is Authorized) {
      final school = currentUser.school;
      if (event is GetAllSchoolArtworkEvent) {
        final artworkResult = await getAllSchoolArt(
          SchoolId(
            schoolId: school.id,
          ),
        );
      }
    }
  }
}
