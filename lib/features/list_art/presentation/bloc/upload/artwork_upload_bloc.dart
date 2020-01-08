import 'dart:async';
import 'package:bloc/bloc.dart';

import 'artwork_upload_event.dart';
import 'artwork_upload_state.dart';

class ArtworkUploadBloc extends Bloc<ArtworkUploadEvent, ArtworkUploadState> {
  @override
  ArtworkUploadState get initialState => InitialArtworkUploadState();

  @override
  Stream<ArtworkUploadState> mapEventToState(
    ArtworkUploadEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
