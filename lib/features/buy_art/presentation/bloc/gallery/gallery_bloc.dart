import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/presentation/bloc/base_artwork_bloc.dart';
import 'package:student_art_collection/core/presentation/bloc/base_artwork_event.dart';
import 'package:student_art_collection/core/presentation/bloc/base_artwork_state.dart';
import 'package:student_art_collection/features/buy_art/domain/repository/buyer_artwork_repository.dart';

part 'gallery_event.dart';

class GalleryBloc extends BaseArtworkBloc<GalleryEvent> {
  final BuyerArtworkRepository artworkRepository;

  GalleryBloc({@required this.artworkRepository});

  @override
  Stream<GalleryState> mapEventToState(GalleryEvent event) async* {
    yield GalleryLoadingState();

    if (event is GetArtworkList) {
      final artworkResult = await artworkRepository.getAllArtwork();
      yield* eitherArtworksOrError(artworkResult, event.sortTypes);
    }
  }
}
