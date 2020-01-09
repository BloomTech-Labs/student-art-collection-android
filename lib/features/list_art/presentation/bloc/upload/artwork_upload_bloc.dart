import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/core/session/session_manager.dart';
import 'package:student_art_collection/core/util/input_converter.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/upload_artwork.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_state.dart';

import 'artwork_upload_event.dart';
import 'artwork_upload_state.dart';
import 'package:meta/meta.dart';

class ArtworkUploadBloc extends Bloc<ArtworkUploadEvent, ArtworkUploadState> {
  final UploadArtwork uploadArtwork;
  final InputConverter converter;
  final SessionManager sessionManager;

  ArtworkUploadBloc({
    @required this.sessionManager,
    @required this.converter,
    @required this.uploadArtwork,
  });

  @override
  ArtworkUploadState get initialState => ArtworkUploadInitial();

  @override
  Stream<ArtworkUploadState> mapEventToState(
    ArtworkUploadEvent event,
  ) async* {
    final currentUser = sessionManager.currentUser;
    if (currentUser is Authorized) {
      if (event is UploadNewArtworkEvent) {
        final artworkToUpload = converter.uploadInfoToArtwork(
          currentUser.school.id,
          event.category,
          event.price,
          event.sold,
          event.title,
          event.artistName,
          event.description,
          event.imageUrls,
        );
        yield* artworkToUpload.fold(
          (failure) async* {
            yield ArtworkUploadError(message: failure.message);
          },
          (artwork) async* {
            yield ArtworkUploadLoading();
            final artworkUploadResult = await uploadArtwork(artwork);
            yield* _eitherUploadedOrErrorState(artworkUploadResult);
          },
        );
      }
    }
  }

  Stream<ArtworkUploadState> _eitherUploadedOrErrorState(
      Either<Failure, Artwork> failureOrArtwork) async* {
    yield failureOrArtwork.fold(
      (failure) {
        return ArtworkUploadError(message: 'Something went wrong');
      },
      (artwork) {
        return ArtworkUploadSuccess(
          artwork: artwork,
        );
      },
    );
  }
}
