import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/core/util/functions.dart';
import 'package:student_art_collection/core/util/text_constants.dart';

import 'base_artwork_filter_type.dart';
import 'base_artwork_sort_type.dart';
import 'base_artwork_state.dart';

abstract class BaseArtworkBloc<EventType>
    extends Bloc<EventType, GalleryState> {
  @override
  GalleryState get initialState => GalleryInitialState();

  @override
  Stream<GalleryState> mapEventToState(EventType event);

  Stream<GalleryState> eitherArtworksOrError(
    Either<Failure, List<Artwork>> failureOrArtworks,
    SortType sortType, {
    Map<String, FilterType> filterTypes,
  }) async* {
    final GalleryState galleryState = failureOrArtworks.fold(
      (failure) {
        if (failure is NetworkFailure) {
          return GalleryErrorState(
              message: TEXT_NETWORK_FAILED_ERROR_MESSAGE_LABEL);
        } else if (failure is PlatformFailure) {
          return GalleryErrorState(
            message: failure.message,
          );
        }
        return GalleryErrorState(message: TEXT_GENERIC_ERROR_MESSAGE_LABEL);
      },
      (artworks) {
        return GalleryLoadedState(artworks);
      },
    );
    yield GalleryLoadingState();
    if (galleryState is GalleryLoadedState) {
      await returnSortedArtworks(galleryState.artworkList, sortType);
      if (filterTypes != null) {
        final List<Artwork> filteredArtworks =
            await returnFilteredArtworks(galleryState.artworkList, filterTypes);
        if (filteredArtworks.length == 0) {
          yield GalleryErrorState(
              message: TEXT_GALLERY_EMPTY_ARTWORKS_MESSAGE_LABEL);
        } else {
          yield GalleryLoadedState(
            filteredArtworks,
          );
        }
      } else
        yield galleryState;
    } else {
      yield galleryState;
    }
  }
}
