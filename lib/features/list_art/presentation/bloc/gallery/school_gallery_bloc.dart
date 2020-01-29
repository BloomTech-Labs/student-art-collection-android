import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/domain/usecase/usecase.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/core/presentation/bloc/base_artwork_bloc.dart';
import 'package:student_art_collection/core/presentation/bloc/base_artwork_state.dart';
import 'package:student_art_collection/core/session/session_manager.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/get_all_school_art.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/logout_school.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_state.dart'
    as auth;
import 'package:student_art_collection/features/list_art/presentation/bloc/gallery/school_gallery_event.dart';
import 'package:meta/meta.dart';

class SchoolGalleryBloc extends BaseArtworkBloc<SchoolGalleryEvent> {
  final GetAllSchoolArt getAllSchoolArt;
  final SessionManager sessionManager;
  final LogoutSchool logoutSchool;

  SchoolGalleryBloc({
    @required this.getAllSchoolArt,
    @required this.sessionManager,
    @required this.logoutSchool,
  });

  @override
  Stream<GalleryState> mapEventToState(
    SchoolGalleryEvent event,
  ) async* {
    final currentUser = sessionManager.currentUser;
    if (currentUser is auth.Authorized) {
      final school = currentUser.school;
      if (event is GetAllSchoolArtworkEvent) {
        final artworkResult = await getAllSchoolArt(
          SchoolId(
            schoolId: school.id,
          ),
        );
        yield* eitherArtworksOrError(
          artworkResult,
          event.sortType,
          filterTypes: event.filterTypes,
        );
      } else if (event is LogoutEvent) {
        yield GalleryLoadingState();
        final logoutResult = await logoutSchool(NoParams());
        yield logoutResult.fold((failure) {
          if (failure is FirebaseFailure)
            return GalleryErrorState(message: failure.message);
          return GalleryErrorState(message: 'Failed to load artworks');
        }, (success) {
          sessionManager.currentUser = null;
          return Unauthorized();
        });
      }
    }
  }
}
