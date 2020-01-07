import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'artwork_details_event.dart';

part 'artwork_details_state.dart';

class ArtworkDetailsBloc
    extends Bloc<ArtworkDetailsEvent, ArtworkDetailsState> {
  @override
  ArtworkDetailsState get initialState => InitialArtworkDetailsState();

  @override
  Stream<ArtworkDetailsState> mapEventToState(
      ArtworkDetailsEvent event) async* {
    // TODO: Add your event logic
  }
}
