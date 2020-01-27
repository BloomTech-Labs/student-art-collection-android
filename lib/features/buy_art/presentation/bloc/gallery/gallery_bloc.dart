import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:student_art_collection/core/domain/entity/artwork.dart';
import 'package:student_art_collection/core/domain/usecase/usecase.dart';
import 'package:student_art_collection/core/presentation/bloc/base_artwork_bloc.dart';
import 'package:student_art_collection/core/presentation/bloc/base_artwork_filter_type.dart';
import 'package:student_art_collection/core/presentation/bloc/base_artwork_sort_type.dart';
import 'package:student_art_collection/core/presentation/bloc/base_artwork_state.dart';
import 'package:student_art_collection/core/util/input_converter.dart';
import 'package:student_art_collection/features/buy_art/domain/repository/buyer_artwork_repository.dart';
import 'package:student_art_collection/features/buy_art/domain/usecase/get_all_artwork.dart';
part 'gallery_event.dart';

class GalleryBloc extends BaseArtworkBloc<GalleryEvent> {
  final GetArtwork getAllArtwork;
  final InputConverter inputConverter;

  GalleryBloc({
    @required this.getAllArtwork,
    @required this.inputConverter,
  });

  @override
  Stream<GalleryState> mapEventToState(GalleryEvent event) async* {
    yield GalleryLoadingState();

    if (event is GetArtworkList) {
      yield* inputConverter.filterTypesToFilters(event.filterTypes).fold(
        (failure) async* {},
        (filters) async* {
          final artworkResult = await getAllArtwork(filters);
          yield* eitherArtworksOrError(
            artworkResult,
            event.sortType,
            filterTypes: event.filterTypes,
          );
        },
      );
    }
  }
}
