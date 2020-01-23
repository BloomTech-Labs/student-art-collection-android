import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/error/failure.dart';

import 'base_artwork_state.dart';

abstract class BaseArtworkBloc<EventType>
    extends Bloc<EventType, GalleryState> {
  @override
  GalleryState get initialState => GalleryInitialState();

  @override
  Stream<GalleryState> mapEventToState(EventType event);

  Stream<GalleryState> eitherArtworksOrError(
      Either<Failure, List<Artwork>> failureOrArtworks) async* {
    yield failureOrArtworks.fold(
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
  }
}
