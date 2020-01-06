import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/features/buy_art/data/repository/artwork_repository_impl.dart';
import 'package:student_art_collection/features/buy_art/domain/repository/artwork_repository.dart';

part 'gallery_event.dart';

part 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final ArtworkRepository artworkRepository;

  GalleryBloc({@required this.artworkRepository});
  @override
  GalleryState get initialState => GalleryInitialState();

  @override
  Stream<GalleryState> mapEventToState(GalleryEvent event) async* {
    yield GalleryLoadingState();
    if(event is GetArtworkList){
        final artworkList = await artworkRepository.getAllArtwork();
        yield* artworkList.fold(
            (failure) async* {
              //TODO: replace message with const
              yield GalleryErrorState(message: "Failed to load Artwork List");
            },
              (artworkList) async* {
              yield GalleryLoadedState(artworkList);
              }
        );
    }
    //TODO Implement Goto details Event
  }
}