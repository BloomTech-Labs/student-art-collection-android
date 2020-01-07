import 'dart:async';
import 'dart:io';
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
      //Mock Data Until Backend is revised
      final artworkList = [Artwork(price: 25,schoolId: 1,artId: 1,images: [Image(imageUrl: "https://picsum.photos/600/900", imageId: 1, artId: 1)]),
        Artwork(price: 25,schoolId: 1,artId: 1,images: [Image(imageUrl: "https://picsum.photos/601/900", imageId: 1, artId: 1)]),
        Artwork(price: 25,schoolId: 1,artId: 1,images: [Image(imageUrl: "https://picsum.photos/602/900", imageId: 1, artId: 1)]),
        Artwork(price: 25,schoolId: 1,artId: 1,images: [Image(imageUrl: "https://picsum.photos/603/900", imageId: 1, artId: 1)]),
        Artwork(price: 25,schoolId: 1,artId: 1,images: [Image(imageUrl: "https://picsum.photos/604/900", imageId: 1, artId: 1)]),
        Artwork(price: 25,schoolId: 1,artId: 1,images: [Image(imageUrl: "https://picsum.photos/605/900", imageId: 1, artId: 1)]),
        Artwork(price: 25,schoolId: 1,artId: 1,images: [Image(imageUrl: "https://picsum.photos/606/900", imageId: 1, artId: 1)]),
        Artwork(price: 25,schoolId: 1,artId: 1,images: [Image(imageUrl: "https://picsum.photos/607/900", imageId: 1, artId: 1)]),
        Artwork(price: 25,schoolId: 1,artId: 1,images: [Image(imageUrl: "https://picsum.photos/608/900", imageId: 1, artId: 1)]),
        Artwork(price: 25,schoolId: 1,artId: 1,images: [Image(imageUrl: "https://picsum.photos/609/900", imageId: 1, artId: 1)]),
        Artwork(price: 25,schoolId: 1,artId: 1,images: [Image(imageUrl: "https://picsum.photos/610/900", imageId: 1, artId: 1)]),
        Artwork(price: 25,schoolId: 1,artId: 1,images: [Image(imageUrl: "https://picsum.photos/611/900", imageId: 1, artId: 1)]),
        Artwork(price: 25,schoolId: 1,artId: 1,images: [Image(imageUrl: "https://picsum.photos/612/900", imageId: 1, artId: 1)]),];
        //final artworkList = await artworkRepository.getAllArtwork();
/*        yield* artworkList.fold(
            (failure) async* {
              //TODO: replace message with const
              yield GalleryErrorState(message: "Failed to load Artwork List");
            },
              (artworkList) async* {
              yield GalleryLoadedState(artworkList);
              }
        );*/
yield GalleryLoadedState(artworkList);
    }
    //TODO Implement Goto details Event
  }
}
