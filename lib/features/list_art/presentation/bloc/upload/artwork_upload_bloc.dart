import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/core/session/session_manager.dart';
import 'package:student_art_collection/core/util/input_converter.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/delete_artwork.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/update_artwork.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/upload_artwork.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/upload_image.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_state.dart';

import '../../list_art_text_constants.dart';
import 'artwork_upload_event.dart';
import 'artwork_upload_state.dart';
import 'package:meta/meta.dart';

class ArtworkUploadBloc extends Bloc<ArtworkUploadEvent, ArtworkUploadState> {
  final UpdateArtwork updateArtwork;
  final UploadArtwork uploadArtwork;
  final HostImage hostImage;
  final DeleteArtwork deleteArtwork;
  final InputConverter converter;
  final SessionManager sessionManager;

  ArtworkUploadBloc({
    @required this.updateArtwork,
    @required this.sessionManager,
    @required this.converter,
    @required this.uploadArtwork,
    @required this.hostImage,
    @required this.deleteArtwork,
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
            yield ArtworkUploadLoading(
              message: TEXT_ARTWORK_UPLOAD_UPLOADING_MESSAGE_LABEL,
            );
            final artworkUploadResult = await uploadArtwork(artwork);
            yield* _eitherUploadedOrErrorState(
              artworkUploadResult,
              TEXT_ARTWORK_UPLOAD_SUCCESS_LABEL,
            );
          },
        );
      } else if (event is UpdateArtworkEvent) {
        final artworkToUpdate = converter.updateInfoToArtwork(
          event.artwork,
          event.category,
          event.price,
          event.sold,
          event.title,
          event.artistName,
          event.description,
          event.imageUrls,
        );
        yield* artworkToUpdate.fold(
          (failure) async* {
            yield ArtworkUploadError(message: failure.message);
          },
          (artwork) async* {
            yield ArtworkUploadLoading(
              message: TEXT_ARTWORK_UPLOAD_UPDATING_MESSAGE_LABEL,
            );
            final artworkUpdateResult = await updateArtwork(artwork);
            yield* _eitherUpdatedOrErrorState(
              artworkUpdateResult,
              TEXT_ARTWORK_UPDATE_SUCCESS_LABEL,
            );
          },
        );
      } else if (event is InitializeEditArtworkPageEvent) {
        yield EditArtworkInitialState(
          artwork: event.artwork,
        );
      } else if (event is HostImageEvent) {
        yield ArtworkUploadLoading(
          message: TEXT_IMAGE_UPLOADING_MESSAGE_LABEL,
        );
        final imageHostResult = await hostImage(event.imageFileToHost);
        yield* _eitherHostedOrErrorState(imageHostResult);
      } else if (event is DeleteArtworkEvent) {
        yield ArtworkUploadLoading();
        final deleteResult =
            await deleteArtwork(ArtworkToDeleteId(artId: event.artId));
        yield* _eitherDeletedOrErrorState(deleteResult);
      }
    }
  }

  Stream<ArtworkUploadState> _eitherUploadedOrErrorState(
      Either<Failure, Artwork> failureOrArtwork, String message) async* {
    yield failureOrArtwork.fold(
      (failure) {
        return ArtworkUploadError(message: TEXT_GENERIC_ERROR_MESSAGE_LABEL);
      },
      (artwork) {
        return ArtworkUploadSuccess(
          artwork: artwork,
          message: message,
        );
      },
    );
  }

  Stream<ArtworkUploadState> _eitherUpdatedOrErrorState(
      Either<Failure, Artwork> failureOrArtwork, String message) async* {
    yield failureOrArtwork.fold(
      (failure) {
        return ArtworkUploadError(message: TEXT_GENERIC_ERROR_MESSAGE_LABEL);
      },
      (artwork) {
        return ArtworkUploadSuccess(
          artwork: artwork,
          message: message,
        );
      },
    );
  }

  Stream<ArtworkUploadState> _eitherDeletedOrErrorState(
      Either<Failure, ArtworkToDeleteId> failureOrId) async* {
    yield failureOrId.fold(
      (failure) {
        return ArtworkUploadError(
            message: TEXT_ARTWORK_DELETE_ERROR_MESSAGE_LABEL);
      },
      (id) {
        return ArtworkDeleteSuccess(artId: id.artId);
      },
    );
  }

  Stream<ArtworkUploadState> _eitherHostedOrErrorState(
      Either<Failure, ReturnedImageUrl> failureOrImageUrl) async* {
    yield failureOrImageUrl.fold(
      (failure) {
        return ArtworkUploadError(
            message: TEXT_GENERIC_IMAGE_HOST_ERROR_MESSAGE_LABEL);
      },
      (imageUrl) {
        return ImageHostSuccess(imageUrl: imageUrl.imageUrl);
      },
    );
  }
}
