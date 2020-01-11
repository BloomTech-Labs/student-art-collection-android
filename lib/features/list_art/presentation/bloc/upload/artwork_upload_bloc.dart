import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/core/session/session_manager.dart';
import 'package:student_art_collection/core/util/input_converter.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/update_artwork.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/upload_artwork.dart';
import 'package:student_art_collection/features/list_art/domain/usecase/upload_image.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_state.dart';

import 'artwork_upload_event.dart';
import 'artwork_upload_state.dart';
import 'package:meta/meta.dart';

class ArtworkUploadBloc extends Bloc<ArtworkUploadEvent, ArtworkUploadState> {
  final UpdateArtwork updateArtwork;
  final UploadArtwork uploadArtwork;
  final HostImage hostImage;
  final InputConverter converter;
  final SessionManager sessionManager;

  ArtworkUploadBloc({
    @required this.updateArtwork,
    @required this.sessionManager,
    @required this.converter,
    @required this.uploadArtwork,
    @required this.hostImage,
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
              message: 'Uploading artwork, please do not close the App.',
            );
            final artworkUploadResult = await uploadArtwork(artwork);
            yield* _eitherUploadedOrErrorState(artworkUploadResult);
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
              message: 'Updating artwork, please do not close the App.',
            );
            final artworkUpdateResult = await updateArtwork(artwork);
            yield* _eitherUploadedOrErrorState(artworkUpdateResult);
          },
        );
      } else if (event is InitializeEditArtworkPageEvent) {
        yield EditArtworkInitialState(
          artwork: event.artwork,
        );
      } else if (event is HostImageEvent) {
        yield ArtworkUploadLoading(
          message: 'Uploading Image',
        );
        final imageHostResult = await hostImage(event.imageFileToHost);
        yield* _eitherHostedOrErrorState(imageHostResult);
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
          message: 'Art was successfully uploaded!',
        );
      },
    );
  }

  Stream<ArtworkUploadState> _eitherHostedOrErrorState(
      Either<Failure, ReturnedImageUrl> failureOrImageUrl) async* {
    yield failureOrImageUrl.fold(
      (failure) {
        return ArtworkUploadError(
            message: 'There was a problem uploading your image');
      },
      (imageUrl) {
        return ImageHostSuccess(imageUrl: imageUrl.imageUrl);
      },
    );
  }
}
