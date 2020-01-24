import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/error/failure.dart';
import 'package:student_art_collection/core/util/functions.dart';

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
      SortType sortType) async* {
    final GalleryState galleryState = failureOrArtworks.fold(
      (failure) {
        if (failure is NetworkFailure) {
          return GalleryErrorState(
              message: 'Check your network connection and try again.');
        }
        return GalleryErrorState(
            message: 'Something went wrong getting your artworks');
      },
      (artworks) {
        return GalleryLoadedState(artworks);
      },
    );
    if (galleryState is GalleryLoadedState) {
      await returnSortedArtworks(galleryState.artworkList, sortType);
      yield galleryState;
    } else {
      yield galleryState;
    }
  }
}
